extends TransferConfig
class_name TransferOrbit

@export var rotation_speed: float = 1.0

func get_position(delta:float, from:Vector2, to:Vector2, progress:float) -> Vector2:
    # rotate around target position while closing in
    var _target_offset: Vector2 = (from - to).normalized()
    var _max_length: float = (from - to).length()
    _target_offset = _target_offset.rotated(delta * rotation_speed).normalized()
    return from + (_target_offset * lerpf(_max_length, 0, progress))
