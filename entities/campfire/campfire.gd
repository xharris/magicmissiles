extends Node2D

@onready var on_hit: OnHit = %OnHit

func context() -> ContextNode:
    var ctx = ContextNode.new()
    ctx.node = self
    ctx.on_hit = on_hit
    ctx.visual_node = %Visual
    return ctx

func _ready() -> void:
    on_hit.source = context()
