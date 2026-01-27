extends Resource
class_name MagicConfig

@export var piercing: bool
## applied to self on ready
@export var on_ready_effects: Array[StatusEffect]
## applied to target on collision
@export var on_hit_effects: Array[StatusEffect]

@export_group("Transfer", "transfer_")
@export var transfer_rotation_speed: float = 10
@export var transfer_duration: float = 1
