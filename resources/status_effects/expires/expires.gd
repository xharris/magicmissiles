extends StatusEffect
class_name StatusExpires

@export var after: float

func apply(ctx: StatusEffectContext):
    var timer = Timer.new()
    timer.one_shot = true
    timer.autostart = true
    timer.wait_time = after
    timer.timeout.connect(_on_timer_timeout.bind(ctx))
    ctx.target.node.add_child(timer)
    
func _on_timer_timeout(ctx: StatusEffectContext):
    if ctx.target.on_hit:
        NodeUtil.disable(ctx.target.on_hit)
    if ctx.target.hurtbox:
        NodeUtil.disable(ctx.target.hurtbox)
    if ctx.target.character:
        NodeUtil.disable(ctx.target.character)
    if ctx.target.visual_node:
        NodeUtil.disable(ctx.target.visual_node)
    if ctx.target.vfx:
        await ctx.target.vfx.disable()
    NodeUtil.remove(ctx.target.node)

func remove():
    pass # TODO remove timer
