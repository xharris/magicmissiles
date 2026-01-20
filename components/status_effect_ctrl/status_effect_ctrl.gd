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
    print("apply status effect", effect.resource_path)
    ctx.target = target
    effect.apply(ctx)

func remove_effect(active: StatusEffectCtrl.Active):
    active_effects = active_effects.filter(
        func(a: StatusEffectCtrl.Active): return a == active
    )
