extends Resource
class_name MagicConfig

@export var piercing: bool
## applied to self on ready
@export var on_ready_effects: Array[StatusEffect]
## applied to target on collision
@export var on_hit_effects: Array[StatusEffect]
@export var hide_sprite: bool

@export var vfx: VfxConfig
@export var active_vfx: VfxConfig

func equals(other: MagicConfig) -> bool:
    return resource_path == other.resource_path
