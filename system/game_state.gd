extends Node


class_name GameState


signal ammo_updated(current_ammo, max_ammon)
signal stamina_updated(new_stamina)
signal max_stamina_changed(new_max_stamina)

signal quit_game_pressed
signal new_game_pressed

signal pause_closed_requested
signal pause_open_requested


var is_pause_available = false

signal survival_timer_finished
var survival_time_remaining : float

func _ready() -> void:
	quit_game_pressed.connect(quit_game)
	new_game_pressed.connect(new_game)

func new_game() -> void:
	SceneManager.change_scene(SceneManager.SCENE_NAME_LEVEL_1)	
	
func quit_game() -> void:
	get_tree().quit()
