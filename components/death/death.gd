@tool
extends SubViewportContainer
class_name Death

@export var enabled: bool = true

func _process(delta: float) -> void:
    if enabled:
        visible = false
