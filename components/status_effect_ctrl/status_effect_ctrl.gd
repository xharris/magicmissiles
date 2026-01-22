extends Node2D
class_name StatusEffectCtrl

class Active extends RefCounted:
    var effect: StatusEffect
    var age: float

var active_effects: Array[Active]

func _process(delta: float) -> void:
    for active in active_effects:
        # status effect expired
        if active.effect.duration and active.age > active.effect.duration:
            pass
        active.age += delta

func apply_effect(target: ContextNode, effect: StatusEffect, ctx: StatusEffectContext):
    ctx.target = target
    var target_is_me = ctx.target.node == ctx.me.node
    var target_is_source = ctx.target.node == ctx.source.node
    if (not ctx.can_hit_me and target_is_me) or (not ctx.can_hit_source and target_is_source):
        print("invalid target, is_me=", target_is_me, ", can_hit_me", ctx.can_hit_me, ", is_source=", target_is_source, ", can_hit_source=", ctx.can_hit_source, " effect=", effect.name)
        return
    print("apply ", effect.name, " to ", target.node, " from ", ctx.source.node, "'s ", ctx.me.node)
    effect.apply(ctx)

func remove_effect(active: StatusEffectCtrl.Active):
    active_effects = active_effects.filter(
        func(a: StatusEffectCtrl.Active): return a == active
    )
