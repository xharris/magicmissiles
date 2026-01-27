@tool
extends CharacterBody2D
class_name Actor

@onready var sprite: ActorSprite = %ActorSprite
@onready var hurtbox: Hurtbox = %Hurtbox
@onready var sense: Sense = %Sense
@onready var on_hit: OnHit = %OnHit
@onready var visual: Node2D = %Visual
@onready var arms: Arms = %Arms
@onready var hp: Hp = %Hp
@onready var status_effect_ctrl: StatusEffectCtrl = %StatusEffectCtrl
@onready var camera: CameraFocus = %CameraFocus

@onready var ai_ctrl: AiControl = %AiControl
@onready var player_ctrl: PlayerControl = %PlayerControl

@export var config: ActorConfig:
    set(v):
        if v != config:
            config = v
            update()
var ai_enabled: bool:
    get():
        return config.ai_config != null
var control: ActorControl:
    get():
        if ai_enabled:
            return ai_ctrl
        else:
            return player_ctrl

@export_tool_button("Update", "Callable")
var update_action = update

var _log = Logs.new("actor")#, Logs.Level.DEBUG)

func context() -> ContextNode:
    var ctx = ContextNode.new()
    if Engine.is_editor_hint():
        return ctx
    ctx.node = self
    ctx.status_ctrl = status_effect_ctrl
    ctx.hurtbox = hurtbox
    ctx.character = self
    ctx.hp = hp
    ctx.faction = config.faction if config else null
    ctx.actor_ctrl = control
    ctx.sense = sense
    ctx.on_hit = on_hit
    return ctx

func update():
    if not config:
        return
    NodeUtil.reconnect_str(config, "changed", update)
    # camera
    if camera:
        camera.config = config.camera
    # hp
    if hp:
        NodeUtil.reconnect_str(hp, "died", _on_died)
    # body
    _update_shapes(self, config.body, Color.html("2196F36b"), config.body_position)
    # visual
    if visual:
        visual.scale = config.visual_scale
    # sprite
    if sprite:
        sprite.config = config.sprite
    # hurtbox
    if hurtbox:
        NodeUtil.reconnect_str(hurtbox, "apply_status_effect", _on_apply_status_effect)
        _update_shapes(hurtbox, config.hurtbox, Color.html("4CAF506b"))
    # control (player/ai)
    if sense:
        sense.radius = config.ai_sense_radius
    if ai_ctrl and player_ctrl:
        ai_ctrl.config = config.ai_config
        if ai_enabled:
            _log.info("%s is ai controlled: %s" % [self, ai_ctrl.config.resource_path.get_basename()])
            NodeUtil.disable(player_ctrl)
            NodeUtil.enable(ai_ctrl)
        else:
            _log.info("%s is player controlled" % [self])
            NodeUtil.enable(player_ctrl)
            NodeUtil.disable(ai_ctrl)
        NodeUtil.reconnect_str(control, "primary", _on_primary)
    # on hit
    if on_hit:
        _update_shapes(on_hit, config.on_hit, Color.html("f443366b"))
        on_hit.set("status_effects", config.on_hit_status_effects)
        on_hit.set("source", context())
    # arms
    if arms:
        if config.arms:
            NodeUtil.enable(arms)
        else:
            NodeUtil.disable(arms)
    if is_visible_in_tree():
        ContextNode.attach_ctx(self, context())

func _update_shapes(node: Node2D, shapes: Array[Shape2D], color: Color, shape_pos: Vector2 = Vector2.ZERO):
    for child in node.get_children():
        if child is CollisionShape2D:
            node.remove_child(child)
    for shape in shapes:
        var collision_shape = CollisionShape2D.new()
        collision_shape.shape = shape
        collision_shape.debug_color = color
        collision_shape.position = shape_pos
        node.add_child(collision_shape)
        
func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        return
    if not control.move_direction.is_zero_approx():
        sprite.face_direction = control.move_direction
    if not control.aim_direction.is_zero_approx():
        sprite.face_direction = control.aim_direction
    # aim
    arms.face_direction = control.aim_direction
    arms.pointing = clamp(remap(\
        (global_position - control.aim_position).length(),
        60, 90, 0, 1), 0, 1)
    # movement
    velocity = velocity.lerp(control.move_direction * config.move_speed, delta * 5)
    sprite.walk_speed = clampf(velocity.length() / config.move_speed, 0, 1)
    move_and_collide(velocity * delta)

func _ready() -> void:
    update()
    
func _on_died():
    queue_free()
    
func _on_apply_status_effect(effect: StatusEffect, ctx: StatusEffectContext):
        # apply effect
    status_effect_ctrl.apply_effect(context(), effect, ctx)

func _on_primary():
    # create magic [missile]
    var magic = Magic.create(context(), config.magic_configs)
    _log.debug("fire magic with configs: %s" % [config.magic_configs.map(func(c:MagicConfig):return c.resource_path)])
    var angle = control.move_direction.angle()
    var magic_position = global_position
    if arms:
        angle = Vector2.from_angle(arms.wand_tip.global_rotation)
        magic_position = arms.wand_tip.global_position
    magic.velocity = angle * 500
    magic.global_position = magic_position
