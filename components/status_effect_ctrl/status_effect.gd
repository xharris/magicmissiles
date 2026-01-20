extends Resource
class_name StatusEffect

@export var name: StringName
@export_range(0, 0, 0.5, "or_greater", "suffix:sec") 
var duration: float

func apply(ctx: StatusEffectContext):
    pass
    
## Called when duration ends or status effect is removed
func remove():
    pass
