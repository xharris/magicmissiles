extends Node2D
class_name CameraFocus

@export var config: CameraFocusConfig
## Camera will be SET to position/zoom of this node (no weight distrib). 
## This will only work for one config.
@export var override: bool

## TODO player aim offset
var offset: Vector2

func _ready() -> void:
    add_to_group(Groups.CAMERA_FOCUS)
