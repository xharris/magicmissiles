extends ActionLeaf

## Vector2
@export var position_key: String

func tick(actor: Node, blackboard: Blackboard) -> int:
    var ctx: ContextNode = ContextNode.get_ctx(actor)
    if not ctx or not ctx.actor_ctrl:
        return FAILURE
    # get target position
    var target: Vector2 = blackboard.get_value(position_key)
    if not target:
        return FAILURE
    ctx.actor_ctrl.move_direction = target - actor.global_position
    # stop at target position
    if (target - ctx.actor_ctrl.global_position).is_zero_approx():
        return FAILURE
    return RUNNING

func interrupt(actor: Node, blackboard: Blackboard) -> void:
    var ctx: ContextNode = ContextNode.get_ctx(actor)
    ctx.actor_ctrl.move_direction = Vector2.ZERO
