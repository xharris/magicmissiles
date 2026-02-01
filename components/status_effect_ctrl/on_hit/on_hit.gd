extends Area2D
class_name OnHit

signal hit(target: Node2D)

@export var disabled: bool:
    set(v):
        disabled = v
        update()
var source: Node2D
@export var status_effects: Array[StatusEffect]

var _log = Logs.new("on_hit")
var _clearing = false
var _body_entered: Array[Node2D]

func context() -> ContextNode:
    var ctx = ContextNode.use(self)
    ctx.on_hit = self
    return ctx

func update():
    if not is_inside_tree():
        return
    context()
    if disabled:
        NodeUtil.disable(self)
        _body_entered.clear()
        monitorable = false
        monitoring = false
    else:
        NodeUtil.enable(self)
        monitorable = true
        monitoring = true

func _ready() -> void:
    area_entered.connect(_on_hit)
    area_exited.connect(_on_body_exited)
    body_entered.connect(_on_hit)
    body_exited.connect(_on_body_exited)
    update()

func _on_hit(body: Node2D):
    if disabled:
        return
    if not _body_entered.has(body):
        _body_entered.append(body)
        hit.emit(body)

func _on_body_exited(body: Node2D):
    _body_entered = _body_entered.filter(func(b: Node2D):
        return b != body)
