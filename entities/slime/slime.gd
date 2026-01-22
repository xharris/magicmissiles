extends CharacterBody2D
class_name Slime

@onready var hurtbox: Hurtbox = %Hurtbox
@onready var status_effect_ctrl: StatusEffectCtrl = %StatusEffectCtrl
@onready var visual: Node2D = %Visual

@export var move_speed: int = 200

func _process(delta: float) -> void:
    var target_velocity = Vector2.ZERO # control.move_direction * move_speed
    velocity = velocity.lerp(target_velocity, delta * 5)
    move_and_collide(velocity * delta)

func _ready() -> void:
    hurtbox.apply_status_effect.connect(_on_apply_status_effect)

func _on_apply_status_effect(effect: StatusEffect, ctx: StatusEffectContext):
    # For now, just print - you can add status effect handling later
    var target = ContextNode.new()
    target.node = self
    target.hurtbox = hurtbox
    target.visual_node = visual
    target.character = self
    status_effect_ctrl.apply_effect(target, effect, ctx)
    
