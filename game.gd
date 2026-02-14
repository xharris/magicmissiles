extends Node2D
class_name Game

static var current: Game

@onready var current_area: Node2D = %Farmhouse
@onready var camera_manager: CameraFocusManager = %CameraFocusManager
@onready var player: Actor = %Player

var _log = Logs.new("game", Logs.Level.DEBUG)
var _loaded_scenes: Dictionary[String, Node2D] = {}

func _init() -> void:
    current = self

func move_to_scene(scene: PackedScene, body: Node2D) -> Node2D:
    if not scene:
        _log.error(true, "move_to_scene called with null scene")
        return current_area
    # load scene
    var area = _loaded_scenes.get(scene.resource_path)
    if not area:
        _log.debug("load new scene: %s" % [scene.resource_path])
        area = scene.instantiate()
    else:
        _log.debug("already loaded scene: %s" % [scene.resource_path])
    _loaded_scenes.set(scene.resource_path, area)
    if not area:
        _log.error(true, "failed to instantiate scene %s" % [scene.resource_path])
        return current_area
    await get_tree().process_frame
    add_child(area)
    _log.debug("loaded next zone: %s" % [scene.resource_path.get_file()])
    # add player to new scene's entities node
    var entities = Entities.find_in(area)
    if entities:
        body.reparent.call_deferred(entities)
    else:
        _log.warn("missing Entities node in new area %s" % [area.name])
    # remove old area
    if current_area:
        remove_child(current_area)
    current_area = area
    return area

func _ready() -> void:
    player.hp.death.connect(_player_death)
    
    # move player into Entities
    var entities = Entities.find_in(current_area)
    if entities:
        player.reparent(entities)
    _loaded_scenes.set(current_area.scene_file_path, current_area)

func _player_death(source: Node2D):
    Death.enable([player, source])
