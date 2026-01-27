extends Node2D
class_name MagicTransfer

const SCENE = preload("res://components/magic_transfer/transfer/magic_transfer.tscn")

static func create(start_position: Vector2, target: Node2D, magic: MagicConfig) -> MagicTransfer:
    var me = MagicTransfer.SCENE.instantiate()
    me._start_position = start_position
    me.target = target
    me._magic = magic
    Events.entity_created.emit(me)
    return me

var target: Node2D
var progress: float

var _animation_position: Vector2
var _start_position: Vector2
var _magic: MagicConfig

func _ready() -> void:
    global_position = _start_position
    _animation_position = _start_position - target.global_position

func _process(delta: float) -> void:
    # rotate around target position while closing in
    _animation_position = _animation_position.rotated(delta * _magic.transfer_rotation_speed)
    var max_length = (target.global_position - _start_position).length()
    global_position = target.global_position + (_animation_position.normalized() * lerpf(max_length, 0, progress))
