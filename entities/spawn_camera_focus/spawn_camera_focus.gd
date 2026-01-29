extends Node2D
class_name SpawnCameraFocus

signal animation_finished

@onready var camera_focus: CameraFocus = %CameraFocus

@export var duration: float = 3

var _config: CameraFocusConfig
var _t: float = 0
var _done: bool = false

func start():
    _config.position_weight = 999
    _config.disable_position_smoothing = true
    _t = 0
    _done = false

func finish():
    if _done:
        return
    _done = true
    _config.disable_position_smoothing = false
    _config.position_weight = 0
    animation_finished.emit()

func _init() -> void:
    _config = CameraFocusConfig.new()
    start()

func _ready() -> void:
    camera_focus.config = _config

func _process(delta: float) -> void:
    if _done:
        return
    _t += delta
    var ratio = ease(clampf(_t / duration, 0, 1), 0.2)
    if ratio >= 1:
        finish()
    # position
    _config.position_weight = lerpf(999, 0, ratio)
    # zoom
    var max_dim = maxf(get_viewport_rect().size.x, get_viewport_rect().size.y)
    _config.zoom = lerpf(max_dim, 0.5, ratio) * Vector2.ONE
    _config.zoom_weight = lerpf(999, 0, ratio)
