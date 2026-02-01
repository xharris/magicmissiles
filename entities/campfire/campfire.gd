extends Node2D
class_name Campfire

@onready var on_hit: OnHit = %OnHit

@export var transfer_config: TransferConfig

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
