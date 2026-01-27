extends Area2D
class_name MagicDest

signal receive_started(magic: MagicConfig)
signal receive_finished(magic: MagicConfig)

class Receiving:
    var magic: MagicConfig
    var dest: MagicDest
    var source: MagicSrc
    var time: float
    var transfer: MagicTransfer
    
    func update():
        transfer.progress = time / source.transfer_duration

@export var receive_target: Node2D
var enabled: bool = false
var magic: Array[MagicConfig]

var _log = Logs.new("magic_dest")#, Logs.Level.DEBUG)
var _receiving: Dictionary[String, Receiving]

func _ready() -> void:
    area_entered.connect(_area_entered)
    area_exited.connect(_area_exited)

func _area_exited(area: Area2D):
    if area is MagicSrc:
        _receiving.erase(area.magic)
        
func _area_entered(area: Area2D):
    if not enabled:
        return
    if area is MagicSrc:
        if not _receiving.has(area.magic.resource_path) and not magic.has(area.magic):
            print(_receiving)
            _log.debug("receive magic start: %s" % [area.magic])
            # show transfer progress
            var recv = Receiving.new()
            recv.magic = area.magic
            recv.dest = self
            recv.source = area
            recv.time = 0
            var target = self
            if receive_target:
                target = receive_target
            recv.transfer = MagicTransfer.create(area.global_position, target, recv.magic)
            _receiving.set(area.magic.resource_path, recv)
            receive_started.emit(area.magic)

func _process(delta: float) -> void:
    visible = enabled
    for recv: Receiving in _receiving.values():
        recv.transfer.progress = recv.time / recv.magic.transfer_duration
        if recv.time >= recv.magic.transfer_duration:
            _receiving.erase(recv.magic.resource_path)
            magic.append(recv.magic)
            _log.debug("receive magic finish: %s" % [recv.magic])
            receive_finished.emit(recv.magic)
        else:
            recv.time += delta
