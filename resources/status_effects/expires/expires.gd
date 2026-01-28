extends StatusEffect
class_name StatusExpires

var _log = Logs.new("expires")#, Logs.Level.DEBUG)

func remove(ctx: StatusEffectContext):
    var ctx_target = get_target(ctx)
    _log.debug("%s expired" % [ctx_target])
    if ctx_target.on_hit:
        NodeUtil.disable(ctx_target.on_hit)
    if ctx_target.hurtbox:
        NodeUtil.disable(ctx_target.hurtbox)
    if ctx_target.character:
        NodeUtil.disable(ctx_target.character)
    if ctx_target.visual_node:
        NodeUtil.disable(ctx_target.visual_node)
    if ctx_target.vfx:
        await ctx_target.vfx.disable()
    NodeUtil.remove(ctx_target.node)
