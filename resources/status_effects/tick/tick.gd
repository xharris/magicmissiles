## Apply status effects every (duration / ticks) second(s)
extends StatusEffect
class_name StatusTick

@export var ticks: int = 2
@export var on_tick: Array[StatusEffect]

var _log = Logs.new("status_tick")#, Logs.Level.DEBUG)

func apply(ctx: StatusEffectContext):
    _start_tick_timer(ctx, ticks-1)
    
func _start_tick_timer(ctx: StatusEffectContext, ticks_left: int):
    var ctx_target = get_target(ctx)
    # apply effects
    for effect in on_tick:
        _log.debug("apply %s" % [effect.name])
        effect.apply(ctx)
        ## TODO also add timer for effect.remove?
    if ticks_left > 0:
        # start timer for next tick
        var timer = Timer.new()
        timer.name = "Timer_%s" % [name]
        timer.set_meta("effect_%s" % [name], true)
        ctx_target.node.add_child(timer)
        timer.timeout.connect(_start_tick_timer.bind(ctx, ticks_left - 1), CONNECT_ONE_SHOT)
        timer.one_shot = true
        timer.start(duration / ticks)
        _log.debug("wait %s sec" % [timer.wait_time])
