extends ActionLeaf

## Vector2
@export var position_key: String

func tick(actor: Node, blackboard: Blackboard) -> int:
    var ctx = ContextNode.use(actor)
    if not ctx or not ctx.actor_ctrl:
        return FAILURE
    # get target position
    var target: Vector2 = blackboard.get_value(position_key)
    if not target:
        return FAILURE
    ctx.actor_ctrl.move_direction = target - actor.global_position
    # stop at target position
    if ctx.actor_ctrl.global_position.distance_to(target) < 10:
        return FAILURE
    return RUNNING

func interrupt(actor: Node, blackboard: Blackboard) -> void:
    var ctx = ContextNode.use(actor)
    ctx.actor_ctrl.move_direction = Vector2.ZERO
    if ctx.character:
        ctx.character.velocity = Vector2.ZERO
