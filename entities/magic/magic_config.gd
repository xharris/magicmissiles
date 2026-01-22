extends Resource
class_name MagicConfig

@export var piercing: bool

## applied to self on ready
@export var on_ready_effects: Array[StatusEffect]
## applied to target on collision
@export var on_hit_effects: Array[StatusEffect]

@export var vfx: VfxConfig # TODO
@export var sprite: Texture2D # TODO
