extends ActorControl
class_name PlayerControl

@export var secondary_hold_time = 2

var _secondary_pressed: bool = false
var _secondary_time: float = 0

func _process(delta: float) -> void:
    if aim_position.is_zero_approx():
        aim_position = get_global_mouse_position()
    else:
        aim_position = aim_position.lerp(get_global_mouse_position(), delta * 10)
    aim_direction = (aim_position - global_position).normalized()
    
    if _secondary_pressed:
        if _secondary_time >= secondary_hold_time:
            _secondary_time = 0
            secondary.emit()
        _secondary_time += delta
    else:
        _secondary_time = 0
    
func _unhandled_input(event: InputEvent) -> void:
    move_direction.x = Input.get_axis("left", "right")
    move_direction.y = Input.get_axis("up", "down")

    if event.is_action_released("primary"):
        primary.emit()

    _secondary_pressed = event.is_action_pressed("secondary", true)
