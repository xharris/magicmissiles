extends StatusEffect
class_name StatusExpires

@export var after: float

func apply(ctx: StatusEffectContext):
    var timer = Timer.new()
    timer.one_shot = true
    timer.autostart = true
    timer.wait_time = after
    timer.timeout.connect(_on_timer_timeout.bind(ctx))
    ctx.target.node.add_child(timer)
    
func _on_timer_timeout(ctx: StatusEffectContext):
    ctx.target.node.queue_free()

func remove():
    pass # TODO remove timer
