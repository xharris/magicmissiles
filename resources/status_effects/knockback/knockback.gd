extends StatusEffect
class_name EffectKnockback

static var _log = Logger.new("knockback")#, Logger.Level.DEBUG)

enum ImpactFrom {SOURCE, TARGET, ME}

@export var impact_from: ImpactFrom = ImpactFrom.SOURCE
@export_range(0, 1, 0.5) var amount: float
@export var amount_curve: Curve = preload("res://resources/status_effects/knockback/knockback_amount_curve.tres")

func apply(ctx: StatusEffectContext):
    var target_ctx = get_target(ctx)
    var target_char = target_ctx.character
    if not target_char:
        _log.debug("knockback: target does not have CharacterBody2D (target=%s)" % [target_ctx])
        return
    # get knock back source position
    var source_position: Vector2
    match impact_from:
        ImpactFrom.ME:
            source_position = ctx.me.character.global_position
        ImpactFrom.SOURCE:
            source_position = ctx.source.node.global_position
        ImpactFrom.TARGET:
            source_position = ctx.target.node.global_position
    # knock back
    var impact_direction: Vector2 = \
        (source_position - target_char.global_position).normalized()
    target_char.velocity = -impact_direction * amount_curve.sample(amount)
    _log.debug("knockback: from %s -> %s %s" % [source_position, target_ctx.node, target_char.velocity])
    
