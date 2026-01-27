extends Resource
class_name AiControlConfig

@export_group("Chase", "chase_")
@export var chase_cooldown: float
@export var chase_time_limit: float

@export_group("Patrol", "patrol_")
@export var patrol_enabled: bool = true
@export var patrol_delay: float = 3
@export var patrol_cooldown: float
@export var patrol_time_limit: float
