extends Area2D
class_name MagicDest

signal receive_started(magic: MagicConfig)
signal receive_finished(magic: MagicConfig)

class Receiving:
    var magic: MagicConfig
    var transfer: MagicTransfer

class Transfer:
    var magic: MagicConfig
    var transfer: MagicTransfer

@export var receive_target: Node2D
var enabled: bool = false
var magic: Array[MagicConfig]:
    get:
        var out: Array[MagicConfig]
        out.assign(_finished.map(func (r: MagicTransfer): return r.magic))
        return out

var _log = Logs.new("magic_dest", Logs.Level.DEBUG)
var _in_progress: Array[MagicConfig]
var _finished: Array[MagicTransfer]
var _want_src: MagicSrc
var _want_timer: float = -1

func release_all_magic():
    _finished.clear()

func can_receive(config: MagicConfig):
    return _want_src == null and not (
        _in_progress.any(func(m:MagicConfig): return m.equals(config)) or
        magic.any(func(m:MagicConfig): return m.equals(config))
    )

func _ready() -> void:
    area_entered.connect(_area_entered)
    area_exited.connect(_area_exited)

func _area_exited(area: Area2D):
    if area is MagicSrc and area == _want_src:
        _want_src = null
        _want_timer = -1
        
func _area_entered(area: Area2D):
    if not enabled:
        return
    if area is MagicSrc:
        if can_receive(area.magic):
            _want_timer = area.magic.transfer_wait_time
            _want_src = area

func _transfer_start(config: MagicConfig, from: Vector2):
    _log.debug("magic transfer start: %s" % [config.resource_path])
    # get transfer target node
    var target = self
    if receive_target:
        target = receive_target
    # create transfer node
    var transfer = MagicTransfer.create(from, target, config)
    transfer.finished.connect(_transfer_finished.bind(transfer))
    _in_progress.append(config)
    receive_started.emit(config)

func _transfer_finished(transfer: MagicTransfer):
    # the magic has arrived
    _in_progress.erase(transfer.magic.resource_path)
    _log.debug("magic transfer finished: %s" % [magic])
    # store it
    _finished.append(transfer)
    receive_finished.emit(transfer.magic)

func _process(delta: float) -> void:
    visible = enabled
    if _want_timer > -1:
        if _want_timer <= 0:
            # can start transfer
            _want_timer = -1
            _transfer_start(_want_src.magic, _want_src.global_position)
        _want_timer -= delta
