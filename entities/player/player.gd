extends CharacterBody2D
class_name Player

static var MAGIC = preload("res://entities/magic/magic.tscn")

@onready var control: ActorControl = %PlayerControl
@onready var sprite: ActorSprite = %ActorSprite

@export var magic_config: MagicConfig

func _ready() -> void:
    control.primary.connect(_on_primary)

func _process(delta: float) -> void:
    sprite.face_direction = control.aim_direction
    velocity = control.move_direction * 150
    move_and_slide()

func _on_primary():
    var magic = MAGIC.instantiate() as Magic
    magic.velocity = control.aim_direction * 500
    magic.config = magic_config
    add_child(magic)
