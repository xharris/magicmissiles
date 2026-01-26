extends RefCounted
class_name ContextNode

static var _log = Logger.new("context_node")

static func get_ctx(node: Node) -> ContextNode:
    if not node.has_meta(Meta.CONTEXT_NODE):
        _log.warn("missing context node for %s" % [node.get_path()])
        var ctx = ContextNode.new()
        ctx.node = node
        return ctx
    return node.get_meta(Meta.CONTEXT_NODE)

static func attach_ctx(node: Node, ctx: ContextNode):
    if not Engine.is_editor_hint():
        node.set_meta(Meta.CONTEXT_NODE, ctx)

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

## TODO why do I need this?
func duplicate() -> ContextNode:
    var dupe = ContextNode.new()
    dupe.node = node
    dupe.hurtbox = hurtbox
    dupe.status_ctrl = status_ctrl
    dupe.vfx = vfx
    dupe.visual_node = visual_node
    dupe.faction = faction
    dupe.sense = sense
    dupe.on_hit = on_hit
    dupe.actor_ctrl = actor_ctrl
    dupe.character = character
    return dupe

func _to_string() -> String:
    return "node=%s, actor_ctrl=%s, hurtbox=%s, status_ctrl=%s, vfx=%s, character=%s, visual_node=%s, faction=%s, sense=%s" % [
        node,
        actor_ctrl != null,
        hurtbox != null,
        status_ctrl != null,
        vfx != null,
        character != null,
        visual_node != null,
        faction.name if faction != null else "none",
        sense.sensed.size() if sense else "null"
    ]
