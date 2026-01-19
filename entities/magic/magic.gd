extends CharacterBody2D
class_name Magic

var config: MagicConfig

var _age: float = 0

func _process(delta: float) -> void:
    if _age > config.duration:
        queue_free()
    _age += delta
    move_and_slide()
