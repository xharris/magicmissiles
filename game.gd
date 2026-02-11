extends Node2D
class_name Game

static var current: Game

@onready var current_area: Node2D = %Forest
@onready var camera_manager: CameraFocusManager = %CameraFocusManager
@onready var player: Actor = %Player

var _log = Logs.new("game")#, Logs.Level.DEBUG)

func _init() -> void:
    current = self
    
func _ready() -> void:
    # move player into Entities
    var entities = Entities.find_in(current_area)
    if entities:
        player.reparent(entities)

func move_to_scene(scene: PackedScene, player: Node2D) -> Node2D:
    if not scene:
        _log.error(true, "move_to_scene called with null scene")
        return current_area
    # load scene
    var area = scene.instantiate()
    if not area:
        _log.error(true, "failed to instantiate scene %s" % [scene.resource_path])
        return current_area
    await get_tree().process_frame
    add_child(area)
    _log.debug("loaded next zone: %s" % [scene.resource_path.get_file()])
    # add player to new scene's entities node
    var entities = Entities.find_in(area)
    if entities:
        player.reparent.call_deferred(entities)
    else:
        _log.warn("missing Entities node in new area %s" % [area.name])
    # hide old area
    if current_area:
        NodeUtil.disable.call_deferred(current_area)
    current_area = area
    return area
