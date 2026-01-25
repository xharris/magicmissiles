extends ActorControl
class_name AiControl

@onready var tree: BeehaveTree = %BeehaveTree

@export var actor: Node:
    set(v):
        actor = v
        update()
@export var enabled: bool = true:
    set(v):
        enabled = v
        update()

var _log = Logger.new("actor_ai")

func _ready() -> void:
    update()

func update():
    if tree:
        tree.actor = actor
        if actor:
            tree.name = "%s AI" % [actor.name]
        if !enabled:
            NodeUtil.disable(tree)
            tree.actor = null
        else:
            NodeUtil.enable(tree)
