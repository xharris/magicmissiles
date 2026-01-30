extends Node2D
class_name Forest

static var TREE = preload("res://entities/tree/tree.tscn")

@onready var wrapped_sprite: WrappedSprite = %WrappedSprite
@onready var camera_manager: CameraFocusManager = %CameraFocusManager
@onready var tilemap: TileMapLayer = %TileMapLayer
@onready var entities: Node2D = %Entities

func _physics_process(delta: float) -> void:
    wrapped_sprite.offset = -camera_manager.get_screen_center_position()

func _ready() -> void:
    Events.entity_created.connect(_on_entity_created)
    
func _on_entity_created(entity: Node2D):
    entities.add_child(entity)
