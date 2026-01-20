extends Area2D
class_name Hurtbox

signal apply_status_effect(effect: StatusEffect, ctx: StatusEffectContext)

var _body_entered: Array[Node2D]

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
    if not _body_entered.has(body):
        _body_entered.append(body)
        
        if body.has_meta("on_hit"):
            var on_hit: OnHit = body.get_meta("on_hit")
            
            for effect in on_hit.status_effects:
                # setup context
                var ctx = StatusEffectContext.new()
                # add me
                ctx.me = ContextNode.new()
                ctx.me.node = body
                # add source
                ctx.source = ContextNode.new()
                ctx.source.node = on_hit.source
                # NOTE ctx.target (hurtbox owner) is typically set in apply_status_effect listeners
                # have listener resolve status effect
                apply_status_effect.emit(effect)
