extends Resource
class_name Filler

## Can leave this empty to not place anything
@export var scene: PackedScene
@export_range(0, 1, 0.1) var chance: float = 1.0
@export var offset_range: Vector2
