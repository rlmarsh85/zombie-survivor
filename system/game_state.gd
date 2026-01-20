extends Node


class_name GameState


signal ammo_updated(current_ammo, max_ammon)
signal stamina_updated(new_stamina)
signal max_stamina_changed(new_max_stamina)

signal quit_game_pressed
signal new_game_pressed

signal close_instructions_pressed
signal open_instructions_pressed

signal close_options_pressed
signal open_options_pressed


func _ready() -> void:
	quit_game_pressed.connect(quit_game)
	new_game_pressed.connect(new_game)

func new_game() -> void:
	SceneManager.change_scene(SceneManager.SCENE_NAME_LEVEL_1)	
	
func quit_game() -> void:
	get_tree().quit()
