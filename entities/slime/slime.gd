extends CharacterBody2D
class_name Slime

@onready var hurtbox: Hurtbox = %Hurtbox
@onready var status_effect_ctrl: StatusEffectCtrl = %StatusEffectCtrl
@onready var visual: Node2D = %Visual
@onready var hp: Hp = %Hp

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
    var target_velocity = Vector2.ZERO # control.move_direction * move_speed
    velocity = velocity.lerp(target_velocity, delta * 5)
    move_and_collide(velocity * delta)

func _ready() -> void:
    hurtbox.apply_status_effect.connect(_on_apply_status_effect)
    hp.died.connect(_on_died)

func _on_died():
    queue_free()

func _on_apply_status_effect(effect: StatusEffect, ctx: StatusEffectContext):
    # apply effect
    status_effect_ctrl.apply_effect(context(), effect, ctx)
    
