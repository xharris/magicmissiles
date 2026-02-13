extends Node2D
class_name Entities

static func find_containing(node: Node) -> Entities:
    for me: Entities in node.get_tree().get_nodes_in_group(Groups.ENTITIES):
        if me.is_ancestor_of(node):
            return me
    return

static func find_in(node: Node) -> Entities:
    for me: Entities in node.get_tree().get_nodes_in_group(Groups.ENTITIES):
        if node.is_ancestor_of(me):
            return me
    return

var _log = Logs.new("entities")#, Logs.Level.DEBUG)

func _ready() -> void:
    add_to_group(Groups.ENTITIES)
    Events.add_entity.connect(_add_entity)

func _add_entity(node: Node2D):
    if not is_inside_tree():
        return
    _log.debug("add %s to %s" % [node.name, get_path()])
    NodeUtil.reparent2(node, self)
