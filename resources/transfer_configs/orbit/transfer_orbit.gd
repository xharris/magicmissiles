extends TransferConfig
class_name TransferOrbit

@export var rotation_speed: float = 1.0
@export var rotations: int = 2

func get_position(delta:float, from:Vector2, to:Vector2, progress:float) -> Vector2:
    progress = ease(progress, 3)
    # calc angle
    var offset = from - to
    var start_angle = to.angle_to_point(from)
    var end_angle = to.angle_to_point(from) + deg_to_rad(rotations * 360)
    var dir = lerpf(start_angle, end_angle, progress) - offset.angle()
    var len = lerpf(offset.length(), 0, progress)
    # rotate around target position while closing in
    return to + (offset.normalized().rotated(dir) * len)
