extends ConditionLeaf

var _log = Logs.new("is_enemy_nearby")#, Logs.Level.DEBUG)

## target_position: Vector2
@export var position_key: String

func tick(actor: Node, blackboard: Blackboard) -> int:
    var ctx = ContextNode.use(actor)
    if not ctx:
        _log.warn("no context")
        blackboard.erase_value(position_key)
        return FAILURE
    # no enemies
    if not ctx.sense or ctx.sense.sensed.is_empty():
        _log.debug("not sensing anything")
        blackboard.erase_value(position_key)
        return FAILURE
    var enemies: Array[Node2D] = ctx.sense.sensed.duplicate()
    # sort enemies distance
    enemies = enemies.filter(func(s:Node2D):
        var s_ctx = ContextNode.use(s)
        return s_ctx and s_ctx.faction and ctx.faction.is_hostile_to(s_ctx.faction))
    # no enemies
    if enemies.is_empty():
        blackboard.erase_value(position_key)
        return FAILURE
    enemies.sort_custom(ArrayUtil.sort_distance(actor))
    blackboard.set_value(position_key, enemies[0].global_position)
    _log.debug("sensed %s" % [enemies[0]])
    return SUCCESS
