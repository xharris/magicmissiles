extends Node2D
class_name Wisp

@onready var on_hit: OnHit = %OnHit
@onready var transfer_container: TransferContainer = %TransferContainer

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
    transfer_container.transfer_started.connect(_transfer_started)
    transfer_container.replenished.connect(_transfer_replenished)
    
func _transfer_replenished(ctx: ContextNode):
    NodeUtil.enable(on_hit)
    
func _transfer_started(transf: Transfer):
    if transfer_container.nodes.is_empty():
        NodeUtil.disable(on_hit)
