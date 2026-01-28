@tool
extends Node2D
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

var _log = Logs.new("vfx")#, Logs.Level.DEBUG)
var _shaded_node: CanvasItem
var _disabled: bool

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
    if _shaded_node:
        particles.process_material = null
        _shaded_node.material = null

func update():
    if not node:
        return
    if line:
        line.width = config.line_width if config else 0
        var gradient: Gradient
        if config and config.line_gradient:
            gradient = config.line_gradient.duplicate()
            gradient.reverse()
        line.gradient = gradient
        line.texture = config.line_texture if config else null
        line.width_curve = config.line_width_curve if config else null
        line.material = config.line_material if config else null
        if not config or line.width > 0:
            line.show()
        else:
            line.hide()
    if particles:
        particles.process_material = config.particles if config else null
        particles.texture = config.particles_texture if config else null
        if config and config.particles_amount > 0:
            particles.amount = config.particles_amount
    _shaded_node = node
    if _shaded_node:
        var mat = config.material if config else null
        _shaded_node.material = mat
    
func _ready() -> void:
    if not Engine.is_editor_hint():
        line.clear_points()
    update()

func _process(delta: float) -> void:
    if not Engine.is_editor_hint():
        ## create new point in line
        if _disabled and config and config.line_max_points > 0 and line.visible:
            line.add_point(global_position)
        if line.get_point_count() > (config.line_max_points if config else 0):
            line.remove_point(0)
            if line.get_point_count() == 0:
                line_finished.emit()
