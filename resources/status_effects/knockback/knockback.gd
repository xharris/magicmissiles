extends StatusEffect
class_name EffectKnockback

static var _log = Logs.new("knockback")#, Logs.Level.DEBUG)

enum ImpactFrom {SOURCE, TARGET, ME}

@export var impact_from: ImpactFrom = ImpactFrom.SOURCE
@export_range(0, 1, 0.5) var amount: float
@export var amount_curve: Curve = preload("res://resources/status_effects/knockback/knockback_amount_curve.tres")
@export var random_impact_direction: bool

func apply(ctx: StatusEffectContext):
    var target_ctx = get_target(ctx)
    var target_char = target_ctx.character
    if not target_char:
        _log.debug("knockback: target does not have CharacterBody2D (target=%s)" % [target_ctx])
        return
    var impact_direction: Vector2
    if random_impact_direction:
        impact_direction = Vector2(randf(), randf()).normalized()
        _log.debug("knockback: random %s" % [impact_direction])
    else:
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
        impact_direction = \
            (source_position - target_char.global_position).normalized()
        _log.debug("knockback: from %s -> %s %s" % [source_position, target_ctx.node, target_char.velocity])
    target_char.velocity = -impact_direction * amount_curve.sample(amount)
