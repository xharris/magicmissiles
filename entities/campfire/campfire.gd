extends Node2D
class_name Campfire

@onready var on_hit: OnHit = %OnHit

var transfer_config: TransferConfig = preload("res://resources/transfer_configs/linear.tres")
# preload("res://resources/transfer_configs/orbit/orbit.tres")

func context() -> ContextNode:
    var ctx = ContextNode.use(self)
    ctx.on_hit = on_hit
    ctx.visual_node = %Visual
    ctx.transfer_container = %TransferContainer
    ctx.transfer_config = transfer_config
    return ctx

func _ready() -> void:
    context()
    on_hit.source = self
