extends Node2D
class_name ActorSprite

@onready var sprite: Node2D = %Sprite
@onready var animation_tree: AnimationTree = %AnimationTree

var face_direction: Vector2
var walk_speed: float

func _process(delta: float) -> void:
    var is_walking = walk_speed > 0.2
    var is_idle = not is_walking
    
    #if face_direction.sign().x < 0:
        #sprite.scale.x = -abs(sprite.scale.x)
    #else:
        #sprite.scale.x = abs(sprite.scale.x)
    # face direction
    animation_tree["parameters/face_dir_x/blend_position"] = face_direction.normalized().x
    # walk animation
    animation_tree["parameters/walk_speed/scale"] = is_walking and walk_speed or 1
    animation_tree["parameters/walk_state/conditions/idle"] = is_idle
    animation_tree["parameters/walk_state/conditions/walking"] = is_walking
