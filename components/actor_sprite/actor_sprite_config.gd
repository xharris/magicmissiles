extends Resource
class_name ActorSpriteConfig

@export_group("Sprite", "sprite_")
@export var sprite: Texture2D
@export var sprite_hframes: int
@export var sprite_vframes: int
## face_left, face_right, idle, walk
@export var animation_library: AnimationLibrary
