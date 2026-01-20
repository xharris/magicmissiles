extends Node2D
class_name Forest

static var TREE = preload("res://entities/tree/tree.tscn")

@onready var wrapped_sprite: WrappedSprite = %WrappedSprite
@onready var camera_manager: CameraFocusManager = %CameraFocusManager
@onready var tilemap: TileMapLayer = %TileMapLayer
@onready var entities: Node2D = %Entities

func _ready() -> void:
    var query = PhysicsPointQueryParameters2D.new()
    var space = get_world_2d().direct_space_state
    for x in range(0, 3000, 16 * 8):
        for y in range(0, 3000, 16 * 5):
            query.position = Vector2(x, y)
            query.collision_mask |= 128
            query.collide_with_areas = true
            query.collide_with_bodies = false
            var shapes = space.intersect_point(query)
            if shapes.is_empty():
                var tree: Node2D = TREE.instantiate()
                tree.global_position = Vector2(
                    x + (randf_range(-1, 1) * 32), 
                    y + (randf_range(-1, 1) * 16))
                entities.add_child(tree)

func _physics_process(delta: float) -> void:
    wrapped_sprite.offset = -camera_manager.get_screen_center_position()
