extends ActorControl
class_name PlayerControl

func _process(delta: float) -> void:
    if aim_position.is_zero_approx():
        aim_position = get_global_mouse_position()
    else:
        aim_position = aim_position.lerp(get_global_mouse_position(), delta * 10)
    aim_direction = (aim_position - global_position).normalized()
    
func _unhandled_input(event: InputEvent) -> void:
    move_direction.x = Input.get_axis("left", "right")
    move_direction.y = Input.get_axis("up", "down")

    if event.is_action_released("primary"):
        primary.emit()
