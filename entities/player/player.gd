extends CharacterBody2D
class_name Player

static var MAGIC = preload("res://entities/magic/magic.tscn")

@onready var control: ActorControl = %PlayerControl
@onready var sprite: ActorSprite = %ActorSprite
@onready var arms: Arms = %Arms

@export var magic_config: MagicConfig

func _ready() -> void:
    control.primary.connect(_on_primary)

func _process(delta: float) -> void:
    sprite.face_direction = control.aim_direction
    # aim
    arms.face_direction = control.aim_direction
    arms.pointing = clamp(remap(\
        (global_position - control.aim_position).length(),
        100, 200, 0, 1), 0, 1)
    # movement
    velocity = control.move_direction * 150
    move_and_slide()

func _on_primary():
    var magic = MAGIC.instantiate() as Magic
    magic.velocity = Vector2.from_angle(arms.wand_tip.global_rotation) * 500
    magic.config = magic_config
    add_child(magic)
    magic.global_position = arms.wand_tip.global_position
