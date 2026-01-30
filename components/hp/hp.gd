extends Node2D
class_name Hp

signal death(source: Node2D)
signal damaged(amount: int)

var max: int = 5
var current: int = 5
var invincible: bool = false

var _log = Logs.new("hp")#, Logs.Level.DEBUG)

## Returns true if damage was successful
func take_damage(amount: int, source: Node2D) -> bool:
    if invincible or current <= 0:
        return false
    if current > 0 and amount > 0:
        current -= amount
        damaged.emit(amount)
        _log.debug("%s took %d damage, at %d hp" % [get_parent(), amount, current])
    if current <= 0:
        _log.debug("%s died" % [get_parent()])
        death.emit(source)
    return true
