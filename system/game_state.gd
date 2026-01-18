extends Node


class_name GameState


signal ammo_updated(current_ammo, max_ammon)
signal stamina_updated(new_stamina)
signal max_stamina_changed(new_max_stamina)

signal quit_game_pressed


func _ready() -> void:
	quit_game_pressed.connect(quit_game)
	
	
func quit_game() -> void:
	get_tree().quit()
