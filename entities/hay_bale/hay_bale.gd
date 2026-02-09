extends Node2D

@onready var hp: Hp = %Hp

func _ready() -> void:
    hp.death.connect(_on_death)
    
func _on_death(source: Node2D):
    queue_free()
