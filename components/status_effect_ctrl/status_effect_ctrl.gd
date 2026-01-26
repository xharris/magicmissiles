extends Node2D
class_name StatusEffectCtrl

var _log = Logger.new("status_effect_ctrl")#, Logger.Level.DEBUG)

class Active extends RefCounted:
    var context: StatusEffectContext
    var effect: StatusEffect
    var age: float

var active_effects: Array[Active]

func _process(delta: float) -> void:
    for active in active_effects:
        # status effect expired
        if active.effect.duration and active.age > active.effect.duration:
            remove_effect(active)
        active.age += delta

func apply_effect(target: ContextNode, effect: StatusEffect, ctx: StatusEffectContext):
    ctx.target = target
    var target_is_me = ctx.target.node == ctx.me.node
    var target_is_source = ctx.target.node == ctx.source.node
    if (not ctx.can_hit_me and target_is_me) or (not ctx.can_hit_source and target_is_source):
        _log.debug("invalid target, is_me=%s, can_hit_me=%s, is_source=%s, can_hit_source=%s, effect=%s" % [
            target_is_me, ctx.can_hit_me, target_is_source, ctx.can_hit_source, effect.name
        ])
        return
    _log.debug("apply %s to %s from %s's %s" % [
        effect.name, target.node, ctx.source.node, ctx.me.node
    ])
    effect.apply(ctx)
    # is ongoing effect
    if effect.duration > 0:
        var active = Active.new()
        active.effect = effect
        active.age = 0
        active.context = ctx
        active_effects.append(active)

func remove_effect(active: StatusEffectCtrl.Active):
    active_effects = active_effects.filter(
        func(a: StatusEffectCtrl.Active): 
            var rm = a == active
            if rm:
                a.effect.remove(a.context)
            return rm
    )
