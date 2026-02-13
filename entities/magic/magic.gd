extends CharacterBody2D
class_name Magic

const SCENE = preload("res://entities/magic/magic.tscn")

static func create(source: Node, config: MagicConfig) -> Magic:
    var me = SCENE.instantiate() as Magic
    me.config = config
    me.source = source
    Events.entity_created.emit(me)
    return me

@onready var on_hit: OnHit = %OnHit
@onready var status_effect_ctrl: StatusEffectCtrl = %StatusEffectCtrl
@onready var vfx: Vfx = %Vfx
@onready var visual: CanvasGroup = %Vfx
@onready var sprite: Sprite2D = %Sprite2D

@export var config: MagicConfig
@export var source: Node2D

var _log = Logs.new("magic")#, Logs.Level.DEBUG)

func context() -> ContextNode:
    var ctx = ContextNode.use(self, source)
    ctx.status_ctrl = status_effect_ctrl
    ctx.vfx = vfx
    ctx.visual_node = visual
    ctx.character = self
    ctx.on_hit = on_hit
    return ctx

func clone() -> Magic:
    var me = create(source, config)
    #me.global_transform = global_transform
    return me

## NOTE must be called when used as a projectile
func activate():
    for effect in config.on_ready_effects:
        # create context
        var ctx = StatusEffectContext.new()
        # add me
        ctx.me = ContextNode.use(self)
        ctx.me.status_ctrl = status_effect_ctrl
        ctx.me.vfx = vfx
        ctx.me.visual_node = vfx
        # add source
        ctx.source = ContextNode.use(source)
        # add target (also me)
        var target = ctx.me.duplicate()
        status_effect_ctrl.apply_effect(target, effect, ctx)
        _log.debug("on ready effects: %s" % [config.on_ready_effects.map(func(c:StatusEffect):return c.name)])
    # apply vfx
    if config.active_vfx:
        vfx.config = config.active_vfx

func _ready() -> void:
    if not config:
        push_error("no magic config, src=", source, ", self=", self)
        queue_free()
        return
    name = "Magic-%s" % [config.resource_path.get_file()]
    _log.debug("created %s" % [name])
    update()

func _on_hit(body: Node2D):
    _log.debug("hit %s" % [body])
    # remove if non-piercing (deferred so hurtbox can process the hit first)
    if not config.piercing:
        queue_free()

func _process(delta: float) -> void:
    move_and_collide(velocity * delta)

func update():
    context()
    if on_hit:
        NodeUtil.reconnect(on_hit.hit, _on_hit)
        on_hit.source = self
        on_hit.status_effects.clear()
        on_hit.status_effects.append_array(config.on_hit_effects)
        _log.debug("on hit effects: %s" % [on_hit.status_effects.map(func(c:StatusEffect):return c.name)])
    if vfx:
        vfx.config = config.vfx if config else null
    
    if sprite:
        var hide_sprite = false
        if config.hide_sprite:
            hide_sprite = true
        if hide_sprite:
            sprite.hide()
        else:
            sprite.show()
            var color = Color.WHITE
            if config.sprite_color != Color.WHITE:
                color = config.sprite_color
            sprite.modulate = color
