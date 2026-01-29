extends Resource
class_name CameraFocusConfig

@export var position_weight: float = 0
@export var focus_outside_view: bool
@export var disable_position_smoothing: bool

@export_group("Zoom", "zoom")
@export_custom(PROPERTY_HINT_LINK, "") var zoom: Vector2 = Vector2.ONE
@export var zoom_weight: float = 1.0
