extends CharacterBody2D
class_name Player

var _log = Logger.new("player")

@onready var control: ActorControl = %PlayerControl
@onready var sprite: ActorSprite = %ActorSprite
@onready var arms: Arms = %Arms
@onready var status_effect_ctrl: StatusEffectCtrl = %StatusEffectCtrl
@onready var hurtbox: Hurtbox = %Hurtbox
@onready var hp: Hp = %Hp



@export var magic_configs: Array[MagicConfig]
@export var move_speed: int = 200

func context() -> ContextNode:
    var ctx = ContextNode.new()
    ctx.node = self
    ctx.status_ctrl = status_effect_ctrl
    ctx.hurtbox = hurtbox
    ctx.character = self
    ctx.hp = hp
    return ctx

func _process(delta: float) -> void:
    sprite.face_direction = control.aim_direction
    # aim
    arms.face_direction = control.aim_direction
    arms.pointing = clamp(remap(\
        (global_position - control.aim_position).length(),
        60, 90, 0, 1), 0, 1)
    # movement
    velocity = velocity.lerp(control.move_direction * move_speed, delta * 5)
    sprite.walk_speed = clampf(velocity.length() / move_speed, 0, 1)
    move_and_collide(velocity * delta)
    
func _ready() -> void:
    control.primary.connect(_on_primary)
    hurtbox.apply_status_effect.connect(_on_apply_status_effect)
    hp.died.connect(_on_died)

func _on_died():
    queue_free()
    
func _on_apply_status_effect(effect: StatusEffect, ctx: StatusEffectContext):
    # apply effect
    status_effect_ctrl.apply_effect(context(), effect, ctx)

func _on_primary():
    # create magic [missile]
    var magic = Magic.create(context(), magic_configs)
    magic.velocity = Vector2.from_angle(arms.wand_tip.global_rotation) * 500
    magic.global_position = arms.wand_tip.global_position
