extends StatusEffect
class_name EffectDamage

@export_range(0,1,0.1) var amount: float = 0
@export var curve: Curve = preload("res://resources/curves/damage_curve.tres")

var _log = Logs.new("damage")#, Logs.Level.DEBUG)

func apply(ctx: StatusEffectContext):
    var hp = ctx.target.hp
    if hp:
        _log.debug("from %s" % [ctx.source])
        var source_node = ctx.source.node if is_instance_valid(ctx.source.node) else null
        hp.take_damage(curve.sample(amount), source_node)
