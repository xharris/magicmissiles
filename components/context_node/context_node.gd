extends RefCounted
class_name ContextNode

static var _log = Logs.new("context_node")

static func use(node: Node, source: Node = null) -> ContextNode:
    if not node:
        return
    var ctx: ContextNode
    if Engine.is_editor_hint():
        return ContextNode.new()
    if not node.has_meta(Meta.CONTEXT_NODE):
        ctx = ContextNode.new()
        node.set_meta(Meta.CONTEXT_NODE, ctx)
    else:
        ctx = node.get_meta(Meta.CONTEXT_NODE)
    ctx.node = node
    if source:
        ctx.source_node = source
    return ctx

var source_node: Node2D
var node: Node2D
var hurtbox: Hurtbox
var status_ctrl: StatusEffectCtrl
var vfx: Vfx
var character: CharacterBody2D
## node containing (or is) all visual elements EXCLUDING vfx
var visual_node: Node2D
var hp: Hp
var faction: Faction
var sense: Sense
var actor_ctrl: ActorControl
var on_hit: OnHit
var transfer_container: TransferContainer
## config to use if node were to be transfered
var transfer_config: TransferConfig
## TODO
var time_scale: float = 1

func duplicate(dupe_node: bool = false) -> ContextNode:
    var dupe = ContextNode.new()
    if dupe_node:
        # Check if node is still valid before accessing it
        if not is_instance_valid(node):
            _log.warn("Cannot duplicate freed node")
            return null
        if node.has_method("clone"):
            dupe.node = node.call("clone")
        else:
            dupe.node = node.duplicate()
        var parent = dupe.node.get_parent()
        if parent:
            parent.remove_child(dupe.node)
    else:
        dupe.node = node
    var ctx = use(dupe.node)
    if ctx:
        return ctx
    dupe.hurtbox = hurtbox
    dupe.status_ctrl = status_ctrl
    dupe.vfx = vfx
    dupe.visual_node = visual_node
    dupe.faction = faction
    dupe.sense = sense
    dupe.on_hit = on_hit
    dupe.actor_ctrl = actor_ctrl
    dupe.character = character
    dupe.transfer_container = transfer_container
    dupe.transfer_config = transfer_config
    return dupe

func _to_string() -> String:
    return "(%s: node=%s source=%s)" % [get_instance_id(), node, source_node]
