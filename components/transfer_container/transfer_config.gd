extends Resource
class_name TransferConfig

@export var duration: float = 3

func get_position(delta:float, from:Vector2, to:Vector2, progress:float) -> Vector2:
    var pos = from.lerp(to, progress)
    return pos
