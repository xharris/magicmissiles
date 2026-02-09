extends Area2D
class_name Portal

enum ID {
    FARMHOUSE_ENTER,
    FARMHOUSE_EXIT,
}

static var portals: Dictionary[ID, Dictionary] = {
    ID.FARMHOUSE_ENTER: {scene=preload("res://levels/forest/farmhouse/farmhouse.tscn"), other=ID.FARMHOUSE_EXIT},
    ID.FARMHOUSE_EXIT: {scene=preload("res://levels/forest/forest.tscn"), other=ID.FARMHOUSE_ENTER},
}

@export var id: ID

var _log = Logs.new("portal", Logs.Level.DEBUG)
var _in_use: Node2D

func _ready() -> void:
    add_to_group(Groups.PORTAL)
    body_entered.connect(_on_body_entered)

func _on_scene_loaded(scene: Node):
    for portal: Portal in get_tree().get_nodes_in_group(Groups.PORTAL):
        pass

func _on_body_entered(body: Node2D):
    if body.is_in_group(Groups.PLAYER):
        var current_scene = get_tree().current_scene
        if current_scene:
            Save.save_scene(current_scene)
        # get next scene
        var config: Dictionary = portals.get(id)
        if not config:
            _log.warn("missing portal config for %s (%s)" % [ID.find_key(id), id])
            return
        var scene:PackedScene = config.get("scene")
        if not scene:
            _log.warn("no 'scene' for portal config %s" % [ID.find_key(id)])
        Save.load_scene(scene)
        
