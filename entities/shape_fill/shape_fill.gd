@tool
extends ShapeGrid
class_name ShapeFill

@onready var nodes: Node2D = %Nodes

@export var filler: Array[Filler]
@export var editor_fill: bool = true:
    set(v):
        editor_fill = v
        update()

var _rng = RandomNumberGenerator.new()

func _ready() -> void:
    changed.connect(_changed)
    super._ready()

func _get_nodes() -> Node2D:
    if nodes:
        return nodes
    # In tool mode, @onready might not be set yet, so find it manually
    return get_node_or_null("%Nodes")

func _changed():
    var nodes_ref = _get_nodes()
    if not nodes_ref:
        return
    NodeUtil.clear_children(nodes_ref)
    if Engine.is_editor_hint() and not editor_fill:
        return
    var weights = filler.map(func(f:Filler):
        return f.chance)
    for point in points:
        var idx = _rng.rand_weighted(weights)
        var fill = filler[idx]
        var scene = fill.scene
        if scene:
            var node: Node2D = scene.instantiate()
            var rand_norm = Vector2(randf_range(-1, 1), randf_range(-1, 1))
            node.global_position = point + (rand_norm * fill.offset_range)
            nodes_ref.add_child(node)
