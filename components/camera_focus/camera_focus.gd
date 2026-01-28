extends Node2D
class_name CameraFocus

@export var config: CameraFocusConfig

## TODO player aim offset
var offset: Vector2

func _ready() -> void:
    add_to_group(Groups.CAMERA_FOCUS)
