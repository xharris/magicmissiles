extends Camera2D
class_name CameraFocusManager

var _log = Logs.new("camera_focus_mgr")

## how much to zoom into [code]pixel_focus[/code]
@export var pixel_focus_ratio: float

func _process(_delta: float) -> void:
    # get cameras
    var cameras: Array[CameraFocus]
    cameras.assign(get_tree().get_nodes_in_group(Groups.CAMERA_FOCUS))
    # final camera values
    var final_position: Vector2 = get_target_position()
    var final_zoom: Vector2
    position_smoothing_enabled = not cameras.any(func(c:CameraFocus): 
        return c.config and c.config.disable_position_smoothing)
    # calculate camera position from focus nodes
    var visible_rect = get_viewport().get_visible_rect()
    var total_position: Vector2 = Vector2.ZERO
    var total_position_weight: float
    for node in cameras:
        if not node.config:
            _log.warn("missing config for %s" % [node.get_path()])
            continue
        if not node.config.focus_outside_view and visible_rect.has_point(node.global_position):
            continue
        total_position += ((node.global_position + node.offset) * node.config.position_weight)
        total_position_weight += node.config.position_weight
    if total_position_weight > 0:
        final_position = total_position / total_position_weight
    # calculate zoom from focus nodes
    var total_zoom: Vector2
    var total_zoom_weight: float
    for node in cameras:
        if not node.config:
            continue
        if not node.config.focus_outside_view and visible_rect.has_point(node.global_position):
            continue
        total_zoom += node.config.zoom * node.config.zoom_weight
        total_zoom_weight += node.config.zoom_weight
    if total_zoom_weight > 0 and not total_zoom.is_zero_approx():
        final_zoom = total_zoom / total_zoom_weight
    # apply final values
    zoom = final_zoom
    global_position = final_position
