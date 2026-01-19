extends ActorControl
class_name PlayerControl

func _process(delta: float) -> void:
    aim_direction = (get_global_mouse_position() - global_position).normalized()
    
func _unhandled_input(event: InputEvent) -> void:
    move_direction.x = Input.get_axis("left", "right")
    move_direction.y = Input.get_axis("up", "down")

    if event.is_action_released("primary"):
        primary.emit()
