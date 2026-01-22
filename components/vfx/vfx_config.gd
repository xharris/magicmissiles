extends Resource
class_name VfxConfig

@export var material: ShaderMaterial

@export_group("Particles", "particles_")
@export var particles: ParticleProcessMaterial
@export var particles_texture: Texture2D
@export var particles_amount: int

@export_group("Line", "line_")
@export var line_width: float
@export var line_gradient: Gradient
@export var line_texture: Texture2D
@export var line_max_points: int = 20
@export var line_width_curve: Curve
@export var line_point_position_offset: Vector2
@export var line_material: Material
