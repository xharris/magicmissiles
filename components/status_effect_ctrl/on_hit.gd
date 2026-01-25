extends Area2D
class_name OnHit

signal hit(target: Node2D)

static func get_on_hit(node: Node2D) -> OnHit:
    return node.get_meta(Meta.ON_HIT)

var source: ContextNode:
    set(v):
        if v and source and source.node != v.node and not _clearing:
            clear()
        source = v
        update()
@export var status_effects: Array[StatusEffect]

var _clearing = false
var _body_entered: Array[Node2D]

func context() -> ContextNode:
    var ctx = source
    if not ctx:
        ctx = ContextNode.new()
    ctx.node = self
    return ctx

func _ready() -> void:
    set_meta(Meta.CONTEXT_NODE, context())
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

func _exit_tree() -> void:
    clear()

func clear():
    _clearing = true
    if source:
        var value: OnHit = source.node.get_meta(Meta.ON_HIT)
        if value == self:
            source.node.remove_meta(Meta.ON_HIT)
        source.node = null
    _clearing = false

func update():
    if not source:
        source = ContextNode.new()
    if not source.node:
        source.node = get_parent()
    if source.node:
        source.node.set_meta(Meta.ON_HIT, self)
