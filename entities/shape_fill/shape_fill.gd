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

func _changed():
    if not nodes:
        return
    # Properly free old children
    for child in nodes.get_children():
        nodes.remove_child(child)
        child.queue_free()
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
            nodes.add_child(node)
            # In tool mode, set owner so nodes persist in the editor
            if Engine.is_editor_hint():
                node.owner = get_tree().edited_scene_root
