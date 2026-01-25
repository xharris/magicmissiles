extends Resource
class_name Faction

enum GoodEvil {NEUTRAL, GOOD, EVIL}
enum LawChaos {NEUTRAL, LAWFUL, CHAOTIC}

@export var name: StringName
@export var good_evil: GoodEvil
@export var law_chaos: LawChaos
@export var attacks: Dictionary[StringName, bool]
@export var helps: Dictionary[StringName, bool]

func is_hostile_to(other: Faction) -> bool:
    return attacks.get(other.name) or \
        (good_evil != GoodEvil.NEUTRAL && good_evil != other.good_evil)
    
func is_ally_to(other: Faction) -> bool:
    return helps.get(other.name) or \
        (good_evil != GoodEvil.NEUTRAL && good_evil != other.good_evil)
