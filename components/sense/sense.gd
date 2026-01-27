@tool
extends Node2D
class_name Sense

@onready var range: Area2D = %Range
@onready var shape: CollisionShape2D = %CollisionShape2D

## Nodes that are currently being sensed
var sensed: Array[Node2D]
var radius: float = 300:
    set(v):
        radius = v
        update()
var enabled: bool = true:
    set(v):
        enabled = v
        update()

var _log = Logs.new("sense")#, Logs.Level.DEBUG)

func update():
    if shape:
        var circle: CircleShape2D = CircleShape2D.new()
        circle.radius = radius
        shape.shape = circle
        if enabled and radius > 0:
            NodeUtil.enable(shape)
        else:
            NodeUtil.disable(shape)

func can_see(node: Node2D) -> bool:
    for s in sensed:
        if s == node or s.is_ancestor_of(node):
            return true
    return false

func _ready() -> void:
    range.body_entered.connect(_on_body_entered)
    range.area_entered.connect(_on_area_entered)
    range.body_exited.connect(_on_body_exited)
    range.area_exited.connect(_on_area_exited)
    update()

func _on_area_exited(area: Area2D):
    _on_body_exited(area)
    
func _on_body_exited(body: Node2D):
    _log.debug("stopped sensing: %s" % [body])
    sensed = sensed.filter(func(s:Node2D): return body != s)

func _on_area_entered(area: Area2D):
    _on_body_entered(area)
    
func _on_body_entered(body: Node2D):
    var parent = get_parent()
    if not sensed.has(body) and parent != body and not parent.is_ancestor_of(body) and not body.is_ancestor_of(self):
        _log.debug("started sensing: %s" % [body])
        sensed.append(body)
