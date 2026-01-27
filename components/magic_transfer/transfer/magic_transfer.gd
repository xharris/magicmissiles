extends Node2D
class_name MagicTransfer

const SCENE = preload("res://components/magic_transfer/transfer/magic_transfer.tscn")

static func create(start_position: Vector2, target: Node2D, magic: MagicConfig) -> MagicTransfer:
    var me = MagicTransfer.SCENE.instantiate()
    me.global_position = start_position
    me.target = target
    me.magic = magic
    Events.entity_created.emit(me)
    return me
    
signal finished

var target: Node2D
var progress: float
var magic: MagicConfig

var _max_length: float
var _target_offset: Vector2
var _time: float
var _done: bool

func _ready() -> void:
    _target_offset = global_position - target.global_position
    _max_length = _target_offset.length()
    _target_offset = _target_offset.normalized()

func _process(delta: float) -> void:
    # increase progression
    _time += delta
    progress = clampf(_time / magic.transfer_duration, 0, 1)
    if progress >= 1 and not _done:
        _done = true
        finished.emit()
    # rotate around target position while closing in
    _target_offset = _target_offset.rotated(delta * magic.transfer_rotation_speed).normalized()
    global_position = target.global_position + (_target_offset * lerpf(_max_length, 0, progress))
