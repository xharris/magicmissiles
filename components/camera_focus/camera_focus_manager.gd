extends Camera2D
class_name CameraFocusManager

func _process(delta: float) -> void:
    var focus_position = get_target_position()
    var visible_rect = get_viewport().get_visible_rect()
      
    var total_position: Vector2
    var total_position_weight: float
    for node: CameraFocus in get_tree().get_nodes_in_group(Groups.CAMERA_FOCUS):
        if node.config.focus_outside_view or visible_rect.has_point(node.global_position):
            total_position += (node.global_position * node.config.position_weight)
            total_position_weight += node.config.position_weight
        
    if total_position_weight > 0:
        focus_position = total_position / total_position_weight
        
    global_position = focus_position
