extends Resource
class_name StatusEffect

enum Target {ME, SOURCE, TARGET}
enum RepeatBehavior {REFRESH, STACK}

var duration_curve: Curve = preload("res://resources/curves/status_effect_duration_curve.tres")

@export_group("General")
@export_placeholder("(auto-generated)") var name: String:
    get:
        if name.is_empty() and not resource_path.is_empty():
            return resource_path.get_file().trim_suffix('.tres')
        return name
@export var target: StatusEffect.Target = StatusEffect.Target.TARGET
@export var can_hit: Dictionary[Target, bool] = {
    StatusEffect.Target.ME: false,
    StatusEffect.Target.SOURCE: false,
    StatusEffect.Target.TARGET: true,
}
## `0` happens for single frame
@export_range(0, 1, 0.1) var duration: float
@export var duration_curve_override: Curve
@export var repeat_behavior: RepeatBehavior
## Should [code]remove[/code] be called on previous instance when refreshing the effect?
@export var remove_on_refresh: bool

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
