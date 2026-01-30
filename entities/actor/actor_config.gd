extends Resource
class_name ActorConfig


@export var faction: Faction
@export var move_speed: int = 200
@export var magic_configs: Array[MagicConfig]

@export var hurtbox: Array[Shape2D]

@export_group("HP")
@export var hp_max: int
@export var remove_on_death: bool = true

@export_group("Body")
@export var body: Array[Shape2D]
@export var body_position: Vector2
@export var on_hit: Array[Shape2D]
@export var on_hit_status_effects: Array[StatusEffect]

@export_group("Visual")
@export_custom(PROPERTY_HINT_LINK, "") var visual_scale = Vector2.ONE
@export var sprite: ActorSpriteConfig
@export var arms: bool
@export var camera: CameraFocusConfig

@export_group("Ai", "ai_")
@export var ai_config: AiControlConfig
## [code]0[/code] disables AI and uses player control
@export var ai_sense_radius: int
