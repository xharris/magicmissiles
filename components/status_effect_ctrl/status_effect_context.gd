extends RefCounted
class_name StatusEffectContext

## The object causing this effect
var me: ContextNode 
## Actor that created created [code]me[/code]
var source: ContextNode
## Who the status effect is being applied to
var target: ContextNode

## TODO do these belong here or in MagicConfig? vvvv
## or maybe this isn't needed at all and I can let the effects
## determine who the target is (also add an on_cast in MagicConfig)

var can_hit_me: bool = false
var can_hit_source: bool = false
