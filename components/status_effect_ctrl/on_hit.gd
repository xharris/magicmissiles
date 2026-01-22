extends Area2D
class_name OnHit
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

func _ready() -> void:    
    update()
    
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
        #set_meta(Meta.SOURCE, source)
        source.node.set_meta(Meta.ON_HIT, self)
