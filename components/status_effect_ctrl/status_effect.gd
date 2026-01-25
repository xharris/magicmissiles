extends Resource
class_name StatusEffect

@export var name: StringName
@export_range(0, 0, 0.5, "or_greater", "suffix:sec")
## `0` happens for single frame
var duration: float

func _init() -> void:
    if name.is_empty():
        pass

## Apply status effect
func apply(ctx: StatusEffectContext):
    pass
    
## Called when duration ends or status effect is removed.
## Will [b]not[/b] be called for effects with [code]0[/code] duration
func remove():
    pass
