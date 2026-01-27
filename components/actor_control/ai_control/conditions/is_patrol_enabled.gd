extends ConditionLeaf

func tick(actor: Node, blackboard: Blackboard) -> int:
    var config: AiControlConfig = blackboard.get_value("config")
    if not config or not config.patrol_enabled:
        return FAILURE
    return SUCCESS
