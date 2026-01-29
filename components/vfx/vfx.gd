@tool
extends CanvasGroup
class_name Vfx

signal line_finished

@onready var particles: GPUParticles2D = %GPUParticles2D
@onready var line: Line2D = %Line2D

@export var config: VfxConfig:
    set(v):
        config = v
        update()
@export var node: CanvasItem:
    set(v):
        if not v:
            v = get_parent()
        if node != v:
            clear()
        node = v
        update()
@export_tool_button("Update")
var update_action = update
@export var preview_animation: bool

var _log = Logs.new("vfx")#, Logs.Level.DEBUG)
var _shaded_node: CanvasItem
var _disabled: bool
var _editor_t: float = 0
var _last_position: Vector2
var _line_point_t: float = 0

func disable():
    _disabled = true
    _log.debug("disable")
    if particles.emitting and particles.process_material:
        particles.emitting = false
        if particles.one_shot:
            _log.debug("disable particles")
            await particles.finished
            _log.debug("disable particles (done)")
        else:
            _log.debug("disable particles (skipped - not one_shot)")
    if line.get_point_count() > 0:
        _log.debug("disable line")
        await line_finished
        _log.debug("disable line (done)")
    _log.debug("disable (done)")

func clear():
    if not is_inside_tree():
        return
    if _shaded_node:
        particles.process_material = null
        _shaded_node.material = null

func update():
    if not node:
        return
    if not is_inside_tree():
        return
    if Engine.is_editor_hint() and config and not config.changed.is_connected(update):
        config.changed.connect(update)
    if line:
        line.width = config.line_width if config else 0
        var gradient: Gradient
        if config and config.line_gradient:
            gradient = config.line_gradient.duplicate()
            if config.line_gradient_reverse:
                gradient.reverse()
        line.gradient = gradient
        line.texture = config.line_texture if config else null
        line.width_curve = config.line_width_curve if config else null
        line.material = config.line_material if config else null
        if not config or line.width > 0:
            line.show()
        else:
            line.hide()
    if particles and config:
        particles.lifetime = config.particles_lifetime
        particles.process_material = config.particles
        particles.texture = config.particles_texture
        particles.fixed_fps = config.particles_fps if config.particles_fps > 0 else 120
        if config.particles_amount > 0:
            particles.amount = config.particles_amount
    _shaded_node = node
    if _shaded_node:
        var mat = config.material if config else null
        _shaded_node.material = mat
    
func _ready() -> void:
    if not Engine.is_editor_hint():
        line.clear_points()
    _last_position = global_position
    update()

func _process(delta: float) -> void:
    if not is_inside_tree():
        return
    if Engine.is_editor_hint():
        if preview_animation:
            _editor_t += delta
            var ratio = (sin(_editor_t) + 1) / 2
            var angle = global_position.angle()
            angle += deg_to_rad(1) * delta * lerp(100, 200, ratio)
            position = Vector2.from_angle(angle) * lerp(50, 100, ratio)
    # calculate direction
    if config and config.particles_calc_direction:
        particles.rotation = _last_position.angle_to_point(global_position)
        _last_position = position
    # create new point in line
    if line:
        var line_point_count = line.get_point_count()
        var line_length = config.line_length if config else 0
        var remove_point = false
        if not _disabled and _line_point_t <= 0 and line_point_count < line_length:
            line.add_point(global_position)
            if line_point_count > line_length:
                ## reached max points
                remove_point = true
        else:   
            remove_point = true
        if remove_point and line_point_count > 0:
            line.remove_point(0)
            if line.get_point_count() == 0:
                line_finished.emit()
    # update camera zoom in shader (if camera_zoom is a uniform)
    var mat: ShaderMaterial = node.material if node else null

    var canv_tform = get_canvas_transform()
    var view_tform = get_viewport_transform()
    if mat and canv_tform:
        #mat.set_shader_parameter("viewport_size", get_viewport_rect().size)
        if config and config.shader_set_camera_scale:
            var camera_zoom = canv_tform.get_scale().length()
            if camera_zoom == 1 and view_tform.get_scale().length() != 1:
                camera_zoom = view_tform.get_scale().length()
            mat.set_shader_parameter("camera_zoom", camera_zoom)
        else:
            mat.set_shader_parameter("camera_zoom", 1)
