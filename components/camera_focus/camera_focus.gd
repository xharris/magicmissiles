extends Node2D
class_name CameraFocus

@export var config: CameraFocusConfig

func _ready() -> void:
    add_to_group(Groups.CAMERA_FOCUS)
