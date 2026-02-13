extends Node2D
class_name Hp

enum DamageType {NORMAL, BURNING, SHOCKING} # ETC

signal death(source: Node2D)
signal damaged(amount: int)

@export var resist_types: Array[DamageType]
@export var current: int = 5

var invincible: bool = false

var _log = Logs.new("hp", Logs.Level.DEBUG)

## Returns true if damage was successful
func take_damage(amount: int, source: Node2D, type:DamageType = DamageType.NORMAL) -> bool:
    if invincible or current <= 0 or resist_types.has(type):
        return false
    if current > 0 and amount > 0:
        current -= amount
        damaged.emit(amount)
        _log.debug("%s took %d damage, at %d hp" % [get_parent(), amount, current])
    if current <= 0:
        _log.debug("%s died" % [get_parent()])
        death.emit(source)
    return true
