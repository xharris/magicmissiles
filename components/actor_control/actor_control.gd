extends Node2D
class_name ActorControl

signal primary

var disable_movement: bool = false

var aim_direction: Vector2:
    set(v):
        if not v:
            v = Vector2.ZERO
        aim_direction = v.normalized()
var move_direction: Vector2:
    set(v):
        if not v:
            v = Vector2.ZERO
        move_direction = v.normalized()
var aim_position: Vector2
