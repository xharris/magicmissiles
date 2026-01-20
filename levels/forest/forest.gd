extends Node2D
class_name Forest

@onready var wrapped_sprite: WrappedSprite = %WrappedSprite
@onready var camera_manager: CameraFocusManager = %CameraFocusManager
@onready var tilemap: TileMapLayer = %TileMapLayer

func _physics_process(delta: float) -> void:
    wrapped_sprite.offset = -camera_manager.get_screen_center_position()
