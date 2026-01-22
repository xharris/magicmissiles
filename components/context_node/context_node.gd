extends RefCounted
class_name ContextNode

var node: Node2D
var hurtbox: Hurtbox
var status_ctrl: StatusEffectCtrl
var vfx: Vfx
var character: CharacterBody2D
## node containing (or is) all visual elements EXCLUDING vfx
var visual_node: Node2D

func duplicate() -> ContextNode:
    var dupe = ContextNode.new()
    dupe.node = node
    dupe.hurtbox = hurtbox
    dupe.status_ctrl = status_ctrl
    dupe.vfx = vfx
    dupe.visual_node = visual_node
    return dupe

func _to_string() -> String:
    return "node=%s, hurtbox=%s, status_ctrl=%s, vfx=%s, character=%s, visual_node=%s" % [
        node,
        hurtbox != null,
        status_ctrl != null,
        vfx != null,
        character != null,
        visual_node != null,
    ]
