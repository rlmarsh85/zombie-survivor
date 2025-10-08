extends StaticBody2D

@export var max_health : int = 100
@export var resistences : ResistenceStats
var current_health : int

func _ready() -> void:
	current_health = max_health

func set_new_health(new_health : int) -> void:
	current_health = new_health

func take_damage(damage_amount : int) -> void:
	set_new_health(current_health - damage_amount)
	if(current_health <= 0):
		crate_destroyed()
		
func get_resistences() -> ResistenceStats:
	return resistences
		
func crate_destroyed() -> void:
	queue_free()
