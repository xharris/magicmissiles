@tool
extends Node2D
class_name ActorSprite

@onready var sprite: Sprite2D = %Sprite2D
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var config: ActorSpriteConfig:
    set(v):
        if config != v:
            config = v
            update()

var face_direction: Vector2
var walk_speed: float

func _process(delta: float) -> void:
    var is_walking = walk_speed > 0.2
    var is_idle = not is_walking
    # face direction
    animation_tree["parameters/face_dir_x/blend_position"] = face_direction.normalized().x
    # walk animation
    animation_tree["parameters/walk_speed/scale"] = is_walking and walk_speed or 1
    animation_tree["parameters/walk_state/conditions/idle"] = is_idle
    animation_tree["parameters/walk_state/conditions/walking"] = is_walking

func _ready() -> void:
    update()

func update():
    if sprite and config:
        sprite.texture = config.sprite
        sprite.hframes = max(1, config.sprite_hframes)
        sprite.vframes = max(1, config.sprite_vframes)
    if animation_player and config:
        animation_player.remove_animation_library("")
        animation_player.add_animation_library("", config.animation_library)
