extends Camera2D
class_name CameraFocusManager

var _log = Logs.new("camera_focus_mgr")

func _process(_delta: float) -> void:
    var focus_position = get_target_position()
    var visible_rect = get_viewport().get_visible_rect()
      
    var total_position: Vector2 = Vector2.ZERO
    var total_position_weight: float
    for node: CameraFocus in get_tree().get_nodes_in_group(Groups.CAMERA_FOCUS):
        if not node.config:
            _log.warn("missing config for %s" % [node.get_path()])
            continue
        if not node.config.focus_outside_view and visible_rect.has_point(node.global_position):
            continue
        total_position += ((node.global_position + node.offset) * node.config.position_weight)
        total_position_weight += node.config.position_weight
        
    if total_position_weight > 0:
        focus_position = total_position / total_position_weight
        
    global_position = focus_position
