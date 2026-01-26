extends RefCounted
class_name StatusEffectContext

## The object causing this effect
var me: ContextNode 
## Actor that created created [code]me[/code]
var source: ContextNode
## Who the status effect is being applied to
var target: ContextNode
