extends Node2D

@onready var sprite: Sprite2D = %Sprite2D

var _t: float = 0
var _wind_strength: float = randf()

func _ready() -> void:
    sprite.material = sprite.material.duplicate()

func _process(delta: float) -> void:
    _t += delta
    var mat: ShaderMaterial = sprite.material
    if mat:
        var _wind_strength_mult = (sin(_t / 10) + 1) / 2
        mat.set_shader_parameter("wind_strength", lerpf(0.07, 0.15, _wind_strength * _wind_strength_mult))
