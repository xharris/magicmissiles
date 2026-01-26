extends ActorControl
class_name AiControl

@onready var tree: BeehaveTree = %BeehaveTree

@onready var chase_cooldown: CooldownDecorator = %ChaseCooldown
@onready var chase_time_limit: TimeLimiterDecorator = %ChaseTimeLimiter

## TODO
@export var config: AiControlConfig:
    set(v):
        config = v
        update()

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
        if config:
            # configure ai nodes
            chase_cooldown.wait_time = config.chase_cooldown
            chase_time_limit.wait_time = config.chase_time_limit
