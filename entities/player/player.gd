extends CharacterBody2D
class_name Player

@onready var control: ActorControl = %PlayerControl
@onready var sprite: ActorSprite = %ActorSprite
@onready var arms: Arms = %Arms
@onready var status_effect_ctrl: StatusEffectCtrl = %StatusEffectCtrl
@onready var hurtbox: Hurtbox = %Hurtbox

@export var magic_configs: Array[MagicConfig]

func _process(delta: float) -> void:
    sprite.face_direction = control.aim_direction
    # aim
    arms.face_direction = control.aim_direction
    arms.pointing = clamp(remap(\
        (global_position - control.aim_position).length(),
        20, 40, 0, 1), 0, 1)
    # movement
    velocity = velocity.lerp(control.move_direction * 150, delta * 5)
    sprite.walk_speed = clampf(velocity.length() / 150, 0, 1)
    move_and_slide()
    
func _ready() -> void:
    control.primary.connect(_on_primary)
    hurtbox.apply_status_effect.connect(_on_apply_status_effect)

func _on_apply_status_effect(effect: StatusEffect, ctx: StatusEffectContext):
    # add me as the target
    var target = ContextNode.new()
    target.node = self
    target.status_ctrl = status_effect_ctrl
    target.hurtbox = hurtbox
    # apply effect
    status_effect_ctrl.apply_effect(target, effect, ctx)

func _on_primary():
    # set source context (me)
    var source = ContextNode.new()
    source.node = self
    source.hurtbox = hurtbox
    source.status_ctrl = status_effect_ctrl
    # create magic [missile]
    var magic = Magic.create(source, magic_configs)
    magic.velocity = Vector2.from_angle(arms.wand_tip.global_rotation) * 200
    magic.global_position = arms.wand_tip.global_position
