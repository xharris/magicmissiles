@tool
extends Node2D
class_name WrappedSprite

@onready var texture_node: Sprite2D = %Sprite2D
@onready var parallax: Parallax2D = %Parallax2D

@export var texture: Texture2D:
    set(v):
        texture = v
        update()

var offset: Vector2

func update():
    if texture and texture_node:
        texture_node.texture = texture

func _ready() -> void:
    update()

func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        update()
