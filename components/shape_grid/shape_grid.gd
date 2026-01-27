@tool
extends Node2D
class_name ShapeGrid

@export var grid_size: Vector2 = Vector2(32, 32):
    set(v):
        grid_size = v
        update()
@export_tool_button("Update")
var update_action = update

var _log = Logs.new("shape_grid")
var _color: Color = Color.html("607D8B6B")
var _rect: Rect2
var _rects: Array[Rect2]
var points: Array[Vector2]

func random_position() -> Vector2:
    if not points.is_empty():
        return points.pick_random()
    return Vector2.ZERO

func update():
    _rects = []
    _rect = Rect2()
    points.clear()
    if not is_inside_tree():
        return
    # get enclosing rect
    var shapes: Array[CollisionShape2D]
    var polygons: Array[PackedVector2Array]
    
    for child in find_children("*"):
        if child is Node2D:
            child.modulate.a = 0.2
            if not child.visible:
                continue
        var rect: Rect2
        if child is CollisionPolygon2D:
            # add polygon
            polygons.append(child.polygon)
            for point: Vector2 in child.polygon:
                rect = rect.expand(point)
        if child is CollisionShape2D:
            # add other shape
            shapes.append(child)
            rect = child.shape.get_rect()
        rect.position += child.position
        _rects.append(rect)
        _rect = _rect.merge(rect)
    # get points in enclosing rect that collide with shapes
    var space = get_world_2d().direct_space_state
    for x in range(_rect.position.x, _rect.end.x, grid_size.x):
        for y in range(_rect.position.y, _rect.end.y, grid_size.y):
            var query = PhysicsPointQueryParameters2D.new()
            query.collide_with_areas = true
            query.collide_with_bodies = true
            query.position = Vector2(x, y)
            var results = space.intersect_point(query)
            # result
            # - collider: The colliding object.
            # - collider_id: The colliding object's ID.
            # - rid: The intersecting object's RID.
            # - shape: The shape index of the colliding shape.
            for result in results:
                var collider = result.get("collider")
                if collider and collider == self or is_ancestor_of(collider):
                    points.append(query.position)
            #points.append(Vector2(x, y ))
    queue_redraw()

func _ready() -> void:
    add_to_group(Groups.SHAPE_GRID)
    child_entered_tree.connect(_child_entered_tree)
    child_exiting_tree.connect(_child_exiting_tree)
    update()

func _child_entered_tree(_child: Node):
    update()

func _child_exiting_tree(_child: Node):
    update()

func _draw() -> void:
    var size = 5
    for pt in points:
        draw_rect(Rect2(pt - Vector2(size/2, size/2), Vector2(size, size)), _color)
    for r in _rects:
        draw_rect(r, _color)
