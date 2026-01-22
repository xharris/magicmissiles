extends StatusEffect
class_name EffectKnockback

static var _log = Logger.new("knockback")

@export_range(0, 1, 0.5) var amount: float
@export var amount_curve: Curve = preload("res://resources/status_effects/knockback/knockback_amount_curve.tres")

func apply(ctx: StatusEffectContext):
    var me_node: Node2D = ctx.me.node
    var target_char: CharacterBody2D = ctx.target.character
    
    if target_char:
        var impact_direction: Vector2 = \
            (me_node.global_position - target_char.global_position).normalized()
        target_char.velocity = -impact_direction * amount_curve.sample(amount)
    else:
        _log.debug("knockback: target does not have CharacterBody2D (%s)" % [ctx.target])
