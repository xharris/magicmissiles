extends StatusEffect
class_name StatusStunned

func apply(ctx: StatusEffectContext):
    var target = get_target(ctx)
    var actor_ctrl = target.actor_ctrl
    var char = target.character
    if char:
        char.velocity = Vector2.ZERO
    if actor_ctrl:
        actor_ctrl.can_aim = false
        actor_ctrl.can_move = false
        actor_ctrl.can_primary = false

func remove(ctx: StatusEffectContext):
    var target = get_target(ctx)
    var actor_ctrl = target.actor_ctrl
    if actor_ctrl:
        actor_ctrl.can_aim = true
        actor_ctrl.can_move = true
        actor_ctrl.can_primary = true
