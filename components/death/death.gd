extends Node2D

@onready var subviewport: SubViewport = %SubViewport
@onready var canvas: CanvasLayer = %CanvasLayer

var _log = Logs.new("death")#, Logs.Level.DEBUG)
var _prev_parent: Dictionary[Node2D, Node2D]
var _time_scale = 1
var _slowdown_duration = 3

func enable(participants: Array[Node2D]):
    _log.debug("enable %s" % [participants])
    for p in participants:
        if not p:
            continue
        # reparent to subviewport so it appears above texturerect
        var parent = p.get_parent()
        _prev_parent.set(p, parent)
        p.reparent.call_deferred(subviewport)
        # quickly reduce time scale of all participants
        ## TODO
    canvas.show()

func disable():
    _log.debug("disable %s" % [_prev_parent.keys()])
    canvas.hide()
    for node in _prev_parent:
        var parent = _prev_parent.get(node)
        if parent:
            node.reparent.call_deferred(parent)

func _ready() -> void:
    disable()
