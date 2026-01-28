extends StatusEffect
class_name EffectDamage

@export_range(0,1,0.1) var amount: float = 0
@export var curve: Curve = preload("res://resources/curves/damage_curve.tres")

func apply(ctx: StatusEffectContext):
    var hp = ctx.target.hp
    if hp:
        hp.take_damage(curve.sample(amount))
