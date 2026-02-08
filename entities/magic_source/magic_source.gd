extends Node2D
class_name MagicSource

@export var on_hit: OnHit
@export var transfer_container: TransferContainer
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
    if on_hit:
        on_hit.source = self
    transfer_container.transfer_started.connect(_transfer_started)
    transfer_container.replenished.connect(_transfer_replenished)
    
func _transfer_replenished(ctx: ContextNode):
    if on_hit:
        NodeUtil.enable(on_hit)
    
func _transfer_started(transf: Transfer):
    if on_hit and transfer_container.nodes.is_empty():
        NodeUtil.disable(on_hit)
