extends Node
class_name ArrayUtil

static func sort_distance(me: Node2D):
    return func(a:Node2D,b:Node2D) -> bool:
        return (b.global_position-me.global_position) < (a.global_position-me.global_position)
