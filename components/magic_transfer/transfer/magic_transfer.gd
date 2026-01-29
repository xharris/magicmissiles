@tool
extends Node2D
class_name MagicTransfer

const SCENE = preload("res://components/magic_transfer/transfer/magic_transfer.tscn")

static func create(start_position: Vector2, target: Node2D, magic: MagicConfig) -> MagicTransfer:
    var me: MagicTransfer = MagicTransfer.SCENE.instantiate()
    me.global_position = start_position
    me.target = target
    me.magic = magic
    Events.entity_created.emit(me)
    return me
    
signal finished

@onready var vfx: Vfx = %Vfx
@onready var sprite: Sprite2D = %Sprite2D

@export var magic: MagicConfig
var target: Node2D
var progress: float

var _max_length: float
var _target_offset: Vector2
var _time: float
var _done: bool

func _ready() -> void:
    _target_offset = global_position - target.global_position
    _max_length = _target_offset.length()
    _target_offset = _target_offset.normalized()

func _process(delta: float) -> void:
    if magic:
        if Engine.is_editor_hint() and vfx and not magic.changed.is_connected(vfx.update):
            magic.changed.connect(vfx.update)
        if magic.transfer_vfx != vfx.config:
            vfx.config = magic.transfer_vfx
        if magic.transfer_sprite_modulate:
            sprite.modulate = magic.transfer_sprite_modulate
        sprite.texture = magic.transfer_sprite
    if not target:
        return
    # increase progression
    _time += delta
    progress = clampf(_time / magic.transfer_duration, 0, 1)
    if progress >= 1 and not _done:
        _done = true
        finished.emit()
    # rotate around target position while closing in
    _target_offset = _target_offset.rotated(delta * magic.transfer_rotation_speed).normalized()
    global_position = target.global_position + (_target_offset * lerpf(_max_length, 0, progress))
