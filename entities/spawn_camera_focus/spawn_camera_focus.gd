extends Node2D
class_name SpawnCameraFocus

signal animation_finished

@onready var camera_focus: CameraFocus = %CameraFocus

@export var disabled: bool
@export var finish_to: CameraFocus
@export var duration: float = 3

var progress: float:
    get:
        if disabled:
            return 1
        return clampf(_t / duration, 0, 1)

var _log = Logs.new("spawn_camera", Logs.Level.DEBUG)
var _config: CameraFocusConfig
var _t: float = 0
var _done: bool = false
var _start_position: Vector2

func start():
    _log.debug("start")
    _start_position = global_position
    _config.disable_position_smoothing = true
    _t = 0
    _done = false

func finish():
    if _done:
        return
    _log.debug("finish")
    _done = true
    camera_focus.override = false
    _config.disable_position_smoothing = false
    _config.zoom_weight = 0
    animation_finished.emit()

func _init() -> void:
    _config = CameraFocusConfig.new()
    start()

func _ready() -> void:
    _start_position = global_position
    camera_focus.config = _config
    if disabled:
        finish()

func _process(delta: float) -> void:
    camera_focus.override = not disabled and progress < 1
    if _done:
        return
    if (disabled or progress >= 1) and not _done:
        finish()
    _t += delta
    var ratio = ease(progress, 0.2)
    # zoom
    var max_dim: Vector2 = Vector2.ONE * minf(get_viewport_rect().size.x, get_viewport_rect().size.y)
    var target_zoom: Vector2 = Vector2.ONE * 0.5
    if finish_to and finish_to.config:
        target_zoom = finish_to.config.zoom
    _config.zoom = lerp(max_dim, target_zoom, ratio)
    # position
    var target_position: Vector2 = global_position
    if finish_to:
        target_position = finish_to.global_position
    # NOTE this uses progress, not ratio (due to easing)
    #global_position = lerp(_start_position, target_position, progress)
