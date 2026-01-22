extends Area2D
class_name Hurtbox

signal apply_status_effect(effect: StatusEffect, ctx: StatusEffectContext)

var _body_entered: Array[Node2D]

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D):
    _on_body_entered(area)

func _on_area_exited(area: Area2D):
    _on_body_exited(area)
    
func _on_body_exited(body: Node2D):
    _body_entered.filter(func(b: Node2D): return b != body)

func _on_body_entered(body: Node2D):
    if not _body_entered.has(body):
        _body_entered.append(body)
        
        var on_hit: OnHit = body
        if on_hit:
            if not on_hit.source:
                push_warning(on_hit, " is missing source")
            else:
                for effect in on_hit.status_effects:
                    # setup context
                    var ctx = StatusEffectContext.new()
                    # add me
                    ctx.me = ContextNode.new()
                    ctx.me.node = body
                    # add source
                    ctx.source = on_hit.source
                    # NOTE ctx.target (hurtbox owner) is typically set in apply_status_effect listeners
                    # have listener resolve status effect
                    apply_status_effect.emit(effect, ctx)
