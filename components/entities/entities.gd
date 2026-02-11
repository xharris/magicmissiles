extends Node2D
class_name Entities

static func find_in(node: Node) -> Entities:
    for me: Entities in node.get_tree().get_nodes_in_group(Groups.ENTITIES):
        if node.is_ancestor_of(me):
            return me
    return

var _log = Logs.new("entities", Logs.Level.DEBUG)

func _ready() -> void:
    add_to_group(Groups.ENTITIES)
    Events.entity_created.connect(_entity_created)

func _entity_created(node: Node2D):
    _log.debug("add %s to %s" % [node.name, get_path()])
