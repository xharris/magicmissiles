extends CharacterBody2D
class_name Magic

const SCENE = preload("res://entities/magic/magic.tscn")

static func create(source: ContextNode, configs: Array[MagicConfig]) -> Magic:
    var me = SCENE.instantiate() as Magic
    me.configs = configs
    me.source = source
    Events.entity_created.emit(me)
    return me

@onready var on_hit: OnHit = %OnHit
@onready var status_effect_ctrl: StatusEffectCtrl = %StatusEffectCtrl

var configs: Array[MagicConfig]:
    set(v):
        configs = v
        update()
var source: ContextNode

func _ready() -> void:
    if configs.is_empty():
        push_error("no magic configs, src=", source, ", self=", self)
        queue_free()
    update()
    for config in configs:
        for effect in config.on_ready_effects:
            # create context
            var ctx = StatusEffectContext.new()
            # add me
            ctx.me = ContextNode.new()
            ctx.me.node = self
            ctx.me.status_ctrl = status_effect_ctrl
            # add source
            ctx.source = source
            # add target (also me)
            var target = ContextNode.new()
            target.node = self
            target.status_ctrl = status_effect_ctrl
            status_effect_ctrl.apply_effect(target, effect, ctx)

func _process(delta: float) -> void:
    move_and_slide()

func update():
    if on_hit:
        set_meta("on_hit", on_hit)
        on_hit.status_effects.clear()
        for config in configs:
            on_hit.status_effects.append_array(config.on_hit_effects)
