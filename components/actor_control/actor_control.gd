extends Node2D
class_name ActorControl

signal primary

var can_move: bool = true
var can_primary: bool = true:
    set(v):
        can_primary = v
        set_block_signals(not can_primary)
var can_aim: bool = true

var aim_direction: Vector2:
    set(v):
        if not v:
            v = Vector2.ZERO
        if not can_aim:
            return
        aim_direction = v.normalized()
        
var move_direction: Vector2:
    set(v):
        if not v:
            v = Vector2.ZERO
        move_direction = v.normalized()
    get:
        if not can_move:
            return Vector2.ZERO
        return move_direction
        
var aim_position: Vector2:
    set(v):
        if not can_aim:
            return
        aim_position = v
