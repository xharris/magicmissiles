extends Area2D
class_name MagicDest

signal receive_started(magic: MagicConfig)
signal receive_finished(magic: MagicConfig)

var _receiving: Dictionary[MagicConfig, float]

var enabled: bool = false
var magic: Array[MagicConfig]

var _log = Logs.new("magic_dest", Logs.Level.DEBUG)

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
        if not _receiving.has(area.magic) and not magic.has(area.magic):
            _log.debug("receive magic start: %s" % [area.magic])
            _receiving.set(area.magic, area.transfer_duration)
            receive_started.emit(area.magic)

func _process(delta: float) -> void:
    visible = enabled
    for m in _receiving:
        var time = _receiving.get(m, 0)
        if time <= 0:
            _receiving.erase(m)
            magic.append(m)
            _log.debug("receive magic finish: %s" % [m])
            receive_finished.emit(m)
        else:
            time -= delta
            _receiving[m] = time
