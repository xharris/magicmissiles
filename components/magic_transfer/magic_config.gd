extends Resource
class_name MagicConfig

@export var piercing: bool
## applied to self on ready
@export var on_ready_effects: Array[StatusEffect]
## applied to target on collision
@export var on_hit_effects: Array[StatusEffect]
@export var vfx: VfxConfig

@export_group("Transfer", "transfer_")
## time to wait for transfer to start
@export var transfer_wait_time: float = 1
@export var transfer_rotation_speed: float = 10
## time to wait for transfer to finish
@export var transfer_duration: float = 1

func equals(other: MagicConfig) -> bool:
    return resource_path == other.resource_path
