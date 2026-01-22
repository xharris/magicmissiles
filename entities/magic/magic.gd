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
@onready var vfx: Vfx = %Vfx

var configs: Array[MagicConfig]:
    set(v):
        configs = v
        update()
var source: ContextNode:
    set(v):
        source = v
        update()

var _log = Logger.new("magic")

func _ready() -> void:
    if configs.is_empty():
        push_error("no magic configs, src=", source, ", self=", self)
        queue_free()
    on_hit.hit.connect(_on_hit)
    
    update()
    for config in configs:
        for effect in config.on_ready_effects:
            # create context
            var ctx = StatusEffectContext.new()
            ctx.can_hit_me = true
            # add me
            ctx.me = ContextNode.new()
            ctx.me.node = self
            ctx.me.status_ctrl = status_effect_ctrl
            ctx.me.vfx = vfx
            ctx.me.visual_node = %Sprite2D
            # add source
            ctx.source = source
            # add target (also me)
            var target = ctx.me.duplicate()
            status_effect_ctrl.apply_effect(target, effect, ctx)

func _on_hit(body: Node2D):
    # remove non-piercing effects
    configs = configs.filter(func(c:MagicConfig):
        return c.piercing)

func _process(delta: float) -> void:
    var collision = move_and_collide(velocity * delta)
    if configs.size() == 0:
        queue_free()

func update():
    if on_hit:
        on_hit.source = source
        on_hit.status_effects.clear()
        for config in configs:
            for eff in config.on_hit_effects:
                on_hit.status_effects.append_array(config.on_hit_effects)
