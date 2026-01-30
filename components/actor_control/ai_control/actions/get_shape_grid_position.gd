extends ActionLeaf

@export var position_key: String
## Only patrol in given group
@export var group: StringName = Groups.PATROL_AREA

func tick(actor: Node, blackboard: Blackboard) -> int:
    var ctx = ContextNode.get_ctx(actor)
    if not ctx:
        return FAILURE
    # get a random shape grid
    var shape_grids: Array[ShapeGrid]
    shape_grids.assign(actor.get_tree().get_nodes_in_group(Groups.SHAPE_GRID))
    shape_grids = shape_grids.filter(func(s:ShapeGrid):
        return s.is_in_group(group))
    if shape_grids.is_empty():
        return FAILURE
    var shape: ShapeGrid = shape_grids.pick_random()
    # get random position
    if shape.points.is_empty():
        return FAILURE
    blackboard.set_value(position_key, shape.random_position())
    return SUCCESS
