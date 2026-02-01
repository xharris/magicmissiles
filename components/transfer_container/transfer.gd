extends Node2D
class_name Transfer

static var SCENE = preload("res://components/transfer_container/transfer.tscn")

static func create(from: TransferContainer, to: TransferContainer, config: TransferConfig, ctx: ContextNode) -> Transfer:
    var me: Transfer = SCENE.instantiate()
    me.from = from
    me.to = to
    me.ctx = ctx
    me.config = config
    me.global_position = from.global_position
    Events.entity_created.emit(me)
    NodeUtil.reparent2(ctx.node, me)
    return me

signal done

var from: TransferContainer
var to: TransferContainer
var ctx: ContextNode
var config: TransferConfig
var progress: float:
    get:
        if not config:
            return 0
        return _t / config.duration

var _log = Logs.new("transfer")#, Logs.Level.DEBUG)
var _t: float = 0
var _done: bool = false
var _target_position: Vector2

func _process(delta: float) -> void:
    if _done:
        return
    _t += delta
    _target_position += (to.global_position - _target_position) * 0.1
    ctx.node.global_position = config.get_position(delta, from.global_position, _target_position, progress)
    if progress >= 1.0:
        _log.debug("done")
        _done = true
        done.emit()

func _ready() -> void:
    _log.debug("from %s to %s" % [from.get_path(), to.get_path()])
    config = config.duplicate()
    _target_position = to.global_position
