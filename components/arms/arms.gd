extends Node2D
class_name Arms

## Wand is pointing at something with a hitbox and context
signal wand_pointing(ctx: ContextNode)

@onready var base: Node2D = %Base
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var arm_l: Node2D = %ArmL
@onready var wand_tip: Node2D = %WandTip
@onready var wand_ray: RayCast2D = %RayCast2D
@onready var transfer_container: TransferContainer = %TransferContainer

var face_direction: Vector2

## 0 is not pointing, 1 is fully pointing 
## (made it a float for joystick)
@export_range(0, 1, 1.0) var pointing: float = 0

var _log = Logs.new("arms", Logs.Level.DEBUG)
var wand_collider: Object

func _process(delta: float) -> void:
    if face_direction.sign().x < 0:
        base.scale.x = -abs(base.scale.x)
    else:
        base.scale.x = abs(base.scale.x)
    # pointing
    animation_tree["parameters/TimeSeek/seek_request"] = pointing * 30
    arm_l.global_rotation = face_direction.angle()

func _physics_process(delta: float) -> void:
    var collider = wand_ray.get_collider()
    if collider and wand_collider != collider:
        var ctx = ContextNode.use(collider)
        if ctx:
            _log.debug("pointing at %s" % [ctx])
            wand_pointing.emit(ctx)
    wand_collider = collider
