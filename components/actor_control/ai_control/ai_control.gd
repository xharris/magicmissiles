extends ActorControl
class_name AiControl

@onready var tree: BeehaveTree = %BeehaveTree

@onready var chase_cooldown: CooldownDecorator = %ChaseCooldown
@onready var chase_time_limit: TimeLimiterDecorator = %ChaseTimeLimiter
@onready var patrol_delay: DelayDecorator = %PatrolDelay
@onready var patrol_cooldown: CooldownDecorator = %PatrolCooldown
@onready var patrol_time_limit: TimeLimiterDecorator = %PatrolTimeLimiter

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

var _log = Logs.new("actor_ai")

func _ready() -> void:
    update()

func update():
    if tree:
        tree.actor = actor
        tree.blackboard.set_value("config", config)
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
            patrol_delay.wait_time = config.patrol_delay
            patrol_cooldown.wait_time = config.patrol_cooldown
            patrol_time_limit.wait_time = config.patrol_time_limit
