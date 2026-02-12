@tool
extends Area2D
class_name Portal

enum ID {
    FARMHOUSE_FRONT_DOOR,
}

static var locked: Array[Node2D]
static var PADDING = 60

## entering a portal will move the player to the next scene in the list
static var portal_scene: Dictionary[ID, Array] = {
    ID.FARMHOUSE_FRONT_DOOR: [
        "res://levels/forest/farmhouse/farmhouse.tscn",
        "res://levels/forest/forest.tscn",
    ],
}

signal finished_using(body: Node2D)

@onready var marker: Marker2D = %Marker2D

@export var id: ID
@export var move_offset: Vector2i:
    set(v):
        move_offset = v
        update()

var _log = Logs.new("portal", Logs.Level.DEBUG)
## where to position the player when the come through the portal
var _move_offset: Vector2:
    get:
        _log.debug("move_offset %v" % [move_offset])
        var out = Vector2(move_offset) * Vector2(74 + PADDING, 58 + PADDING)
        _log.debug("_move_offset %v" % [out])
        return out
var game_scene_path: String

func update() -> void:
    if not Engine.is_editor_hint():
        return
    if marker:
        marker.position = _move_offset
        
func is_eq(other: Portal):
    return get_path() == other.get_path()    
    
func can_use(body: Node2D):
    return not locked.has(body)

func _ready() -> void:
    _log.set_prefix("%s-%d" % [ID.find_key(id), get_tree().get_node_count_in_group(Groups.PORTAL)])
    add_to_group(Groups.PORTAL)
    body_entered.connect(_body_entered)
    update()

func _body_entered(body: Node2D) -> void:
    if not body.is_in_group(Groups.PLAYER):
        return
        
    if not can_use(body):
        return

    var scenes: Array = portal_scene.get(id)
    if scenes.is_empty():
        _log.warn("No scene configured for portal %s" % ID.find_key(id))
        return

    # Find next scene in cycle
    var current_path := Game.current.current_area.scene_file_path
    var idx := scenes.find(current_path)
    if idx == -1:
        _log.error(true, "Current scene not found in portal config")
        return

    idx = wrapi(idx + 1, 0, scenes.size())
    var next_scene_path: String = scenes[idx]

    var packed: PackedScene = load(next_scene_path)
    if not packed or not packed.can_instantiate():
        _log.error(true, "Invalid scene: %s" % next_scene_path)
        return

    _log.debug("%s entering portal %s -> %s" % [
        body.name,
        ID.find_key(id),
        next_scene_path.get_file()
    ])
    
    locked.append(body)

    var next_scene := await Game.current.move_to_scene(packed, body)

    # Find matching portal in new scene
    var other_portal: Portal = null
    for p: Portal in next_scene.get_tree().get_nodes_in_group(Groups.PORTAL):
        if next_scene.is_ancestor_of(p) and p.id == id:
            other_portal = p
            break

    if not other_portal:
        _log.warn("Missing matching portal in destination scene")
        return
        
    var portal_offset = other_portal.global_position + other_portal._move_offset
    #var scene_offset = global_position - other_portal.global_position + _move_offset
    _log.debug("use portal offset: %v" % [portal_offset])

    next_scene.get_viewport().get_camera_2d().position_smoothing_enabled = false
    body.global_position = portal_offset
    #next_scene.global_position = scene_offset
    await next_scene.get_tree().process_frame
    await next_scene.get_tree().physics_frame
    next_scene.get_viewport().get_camera_2d().position_smoothing_enabled = true

    locked.erase(body)
