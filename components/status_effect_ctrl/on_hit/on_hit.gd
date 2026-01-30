extends Area2D
class_name OnHit

signal hit(target: Node2D)

var source: ContextNode:
    set(v):
        source = v.duplicate()
        update()
@export var status_effects: Array[StatusEffect]

var _log = Logs.new("on_hit")
var _clearing = false
var _body_entered: Array[Node2D]

func context() -> ContextNode:
    var ctx = source
    if not ctx:
        _log.warn("missing source for %s" % [self])
        ctx = ContextNode.new()
        ctx.node = self
    ctx.on_hit = self
    return ctx

func _ready() -> void:
    area_entered.connect(_on_hit)
    area_exited.connect(_on_body_exited)
    body_entered.connect(_on_hit)
    body_exited.connect(_on_body_exited)
    update()

func _on_hit(body: Node2D):
    if not _body_entered.has(body):
        _body_entered.append(body)
        hit.emit(body)

func _on_body_exited(body: Node2D):
    _body_entered = _body_entered.filter(func(b: Node2D):
        return b != body)

func update():
    if not source:
        source = ContextNode.new()
    if not source.node:
        source.node = get_parent()
    ContextNode.attach_ctx(self, context())
