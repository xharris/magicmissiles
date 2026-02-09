extends Node2D
class_name UseContextNode

@export var node: Node2D
@export var hurtbox: Hurtbox
@export var status_ctrl: StatusEffectCtrl
@export var vfx: Vfx
@export var character: CharacterBody2D
## node containing (or is) all visual elements EXCLUDING vfx
@export var visual_node: Node2D
@export var hp: Hp
@export var faction: Faction
@export var sense: Sense
@export var actor_ctrl: ActorControl
@export var on_hit: OnHit
@export var transfer_container: TransferContainer
## config to use if node were to be transfered
@export var transfer_config: TransferConfig

func context():
    var _node = node if node else owner
    var ctx = ContextNode.use(_node)
    ctx.node = _node
    ctx.hurtbox = hurtbox
    ctx.status_ctrl = status_ctrl
    ctx.vfx = vfx
    ctx.character = character
    ctx.visual_node = visual_node
    ctx.hp = hp
    ctx.faction = faction
    ctx.sense = sense
    ctx.actor_ctrl = actor_ctrl
    ctx.on_hit = on_hit
    ctx.transfer_container = transfer_container
    ctx.transfer_config = transfer_config
    return ctx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    context()
