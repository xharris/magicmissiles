extends Node2D
class_name ActorSprite

@onready var sprite: Sprite2D = %Sprite2D

var face_direction: Vector2

func _process(delta: float) -> void:
    if face_direction.sign().x < 0:
        sprite.scale.x = -abs(sprite.scale.x)
    else:
        sprite.scale.x = abs(sprite.scale.x)
