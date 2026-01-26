extends Resource
class_name ActorConfig

@export var faction: Faction
@export var hp_max: int
@export var move_speed: int = 200
@export var magic_configs: Array[MagicConfig]

@export var hurtbox: Array[Shape2D]

@export_group("Body", "body")
@export var body: Array[Shape2D]
@export var body_position: Vector2

@export_group("Visual")
@export_custom(PROPERTY_HINT_LINK, "") var visual_scale = Vector2.ONE
@export var sprite: ActorSpriteConfig
@export var arms: bool
@export var camera: CameraFocusConfig

@export_group("Ai", "ai_")
@export var ai_config: AiControlConfig
## [code]0[/code] disables AI and uses player control
@export var ai_sense_radius: int

@export_group("Body On Hit", "on_hit_")
@export var on_hit: Array[Shape2D]
@export var on_hit_status_effects: Array[StatusEffect]
