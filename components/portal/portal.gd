extends Area2D
class_name Portal

signal finished_using(body: Node2D)

enum ID {
    FARMHOUSE_FRONT_DOOR,
}

## entering a portal will move the player to the next scene in the list
static var portal_scene: Dictionary[ID, Array] = {
    ID.FARMHOUSE_FRONT_DOOR: [
        "res://levels/forest/farmhouse/farmhouse.tscn",
        "res://levels/forest/forest.tscn",
    ],
}

@export var id: ID

var _log = Logs.new("portal")#, Logs.Level.DEBUG)
var _in_use: Node2D

func _is_using(body: Node2D):
    return _in_use == body

func _set_using(body: Node2D):
    _log.debug("%s is using portal" % [body])
    _in_use = body
    body.process_mode = Node.PROCESS_MODE_DISABLED

func _set_done_using(body: Node2D):
    _log.debug("%s no longer using portal" % [body])
    _in_use = null
    body.process_mode = Node.PROCESS_MODE_INHERIT
    finished_using.emit(body)

func _ready() -> void:
    _log.set_prefix("%s-%d" % [ID.find_key(id), get_tree().get_node_count_in_group(Groups.PORTAL)])
    add_to_group(Groups.PORTAL)
    body_entered.connect(_body_entered)
    
func _other_portal_body_exited(body: Node2D, other_portal: Portal):
    _set_done_using(body)
    other_portal._set_done_using(body)

func _body_entered(body: Node2D):
    if not _is_using(body) and body.is_in_group(Groups.PLAYER):
        if not Game.current or not Game.current.current_area:
            _log.error(true, "Game.current or current_area is null")
            return
        # get next scene
        var scenes: Array = portal_scene.get(id)
        if not scenes:
            _log.warn("no 'scene' for portal config %s" % [ID.find_key(id)])
            return
        # get next scene
        var idx = scenes.find_custom(func(s: String):
            return s == Game.current.current_area.scene_file_path)
        idx = wrapi(idx + 1, 0, scenes.size())
        var scene_path: String = scenes.get(idx)
        var scene: PackedScene = load(scene_path)
        if not scene or not scene.can_instantiate():
            _log.error(true, "invalid scene, idx=%d" % [idx])
            return
        _set_using(body)
        _log.debug("%s entered %s (%s -> %d:%s)" % [
            body.name, 
            ID.find_key(id), 
            Game.current.current_area.scene_file_path.get_file(), 
            idx,
            scene.resource_path.get_file()
        ])
        var next_scene = await Game.current.move_to_scene(scene, body)
        # find other portal
        var other_portal: Portal
        for p: Portal in get_tree().get_nodes_in_group(Groups.PORTAL):
            if next_scene.is_ancestor_of(p) and p.id == id:
                other_portal = p
        if not other_portal:
            _log.warn("next zone is missing matching portal (%s)" % [ID.find_key(id)])
        else:
            # reset when player leaves other portal
            other_portal._in_use = body
            # move scene so portals line up
            var scene_offset = global_position - other_portal.global_position
            _log.debug("scene offset %v" % [scene_offset])
            next_scene.global_position = scene_offset
            _set_done_using(body)
