extends Resource
class_name StatusEffect

enum Target {ME, SOURCE, TARGET}

@export var name: StringName
@export_range(0, 0, 0.5, "or_greater", "suffix:sec")
## `0` happens for single frame
var duration: float
@export var target: Target = Target.TARGET

func _init() -> void:
    if name.is_empty():
        pass

func get_target(ctx: StatusEffectContext) -> ContextNode:
    match target:
        Target.ME:
            return ctx.me
        Target.SOURCE:
            return ctx.source
    return ctx.target

## Apply status effect
func apply(ctx: StatusEffectContext):
    pass
    
## Called when duration ends or status effect is removed.
## Will [b]not[/b] be called for effects with [code]0[/code] duration
func remove(ctx: StatusEffectContext):
    pass
