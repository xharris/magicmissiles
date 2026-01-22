extends Node2D
class_name Arms

@onready var base: Node2D = %Base
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var arm_l: Node2D = %ArmL
@onready var wand_tip: Node2D = %WandTip

var face_direction: Vector2

## 0 is not pointing, 1 is fully pointing 
## (made it a float for joystick)
@export_range(0, 1, 1.0) var pointing: float = 0

func _process(delta: float) -> void:
    if face_direction.sign().x < 0:
        base.scale.x = -abs(base.scale.x)
    else:
        base.scale.x = abs(base.scale.x)
    # pointing
    animation_tree["parameters/TimeSeek/seek_request"] = pointing * 30
    arm_l.global_rotation = face_direction.angle()
