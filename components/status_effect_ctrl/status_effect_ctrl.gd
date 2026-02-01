extends Node2D
class_name StatusEffectCtrl

var _log = Logs.new("status_effect_ctrl")#, Logs.Level.DEBUG)

class Active extends RefCounted:
    var context: StatusEffectContext
    var effect: StatusEffect
    var age: float
    var age_limit: float

var active_effects: Array[Active]

func _process(delta: float) -> void:
    for active in active_effects:
        # status effect expired
        if active.age_limit > 0 and active.age > active.age_limit:
            remove_effect(active)
        active.age += delta

func get_active(effect: StatusEffect) -> Array[Active]:
    return active_effects.filter(func(a:Active): return a.effect.name == effect.name)

func is_active(effect: StatusEffect):
    return active_effects.any(func(a:Active): return a.effect.name == effect.name)

func apply_effect(target: ContextNode, effect: StatusEffect, ctx: StatusEffectContext):
    if not ctx.source:
        return
    # repeated effect?
    match effect.repeat_behavior:
        StatusEffect.RepeatBehavior.REFRESH:
            # remove previous actives
            var previous = get_active(effect)
            _log.debug("refresh %s (remove %d)" % [effect.name, previous.size()])
            for prev in previous:
                remove_effect(prev, effect.remove_on_refresh)
    # get who is involved
    ctx.target = target
    var target_is_me = ctx.target.node == ctx.me.node
    var target_is_source = ctx.target.node == ctx.source.node
    # check if source/target is valid
    if (not effect.can_hit[StatusEffect.Target.ME] and target_is_me) or\
       (not effect.can_hit[StatusEffect.Target.SOURCE] and target_is_source):
        _log.debug("invalid target, is_me=%s, is_source=%s, can_hit=%s,  effect=%s" % [
            target_is_me, target_is_source, effect.can_hit, effect.name
        ])
        return
    _log.debug("apply %s to %s from %s's %s" % [
        effect.name, target.node, ctx.source.node, ctx.me.node
    ])
    if not effect.get_target(ctx):
        _log.warn("target not found during apply effect %s" % [effect.name])
        return
    effect.apply(ctx)
    # is ongoing effect
    if effect.duration > 0:
        # get duration curve
        var duration_curve = effect.duration_curve_override
        if not duration_curve:
            duration_curve = effect.duration_curve
        # create active effect
        var active = Active.new()
        active.effect = effect
        active.age = 0
        active.age_limit = duration_curve.sample(effect.duration)
        active.context = ctx
        active_effects.append(active)

func remove_effect(active: StatusEffectCtrl.Active, skip_call_remove: bool = false):
    active_effects = active_effects.filter(
        func(a: StatusEffectCtrl.Active): 
            var rm = a == active
            if rm:
                if not a.effect.get_target(a.context):
                    _log.warn("target not found during remove effect %s" % [a.effect.name])
                    return not rm
                if not skip_call_remove:
                    a.effect.remove(a.context)
            return not rm
    )
