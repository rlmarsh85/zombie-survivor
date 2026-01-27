extends Node


class_name ZombieLevel

@export var zombie_spawaner: PackedScene
@onready var player = $Player
@onready var hud = $HUD/MenuHUD
@onready var gameplay_hud = $HUD/GameplayHUD
@onready var survival_timer = $SurvivalTimer

@export var survival_time_for_level : float = 1.0

func _ready() -> void:
	player.hide()
	stop_spawning()
	hud.display_start_button()
	GameStatus.survival_time_remaining = survival_time_for_level
	survival_timer.wait_time = survival_time_for_level
	GameStatus.is_pause_available = false
	gameplay_hud.visible = false


func _on_player_player_died() -> void:
	stop_spawning()
	get_tree().call_group("enemies", "stop_moving")
	hud.restart_display()


func _on_hud_go_button_pressed() -> void:	
	get_tree().call_group("enemies", "queue_free")
	GameStatus.is_pause_available = true
	player.resurrect()
	hud.hide_display()
	gameplay_hud.visible = true
	survival_timer.start()
	player.show()
	start_spawning()
	
func stop_spawning():
	var spawn_zones = get_tree().get_nodes_in_group("spawns")
	for zone in spawn_zones:
		zone.stop_timer()
	
	
func start_spawning():
	var spawn_zones = get_tree().get_nodes_in_group("spawns")
	for zone in spawn_zones:
		zone.start_timer()


func _process(delta : float) -> void:
	if(!survival_timer.is_stopped()):
		GameStatus.survival_time_remaining = survival_timer.time_left


func _on_survival_timer_timeout() -> void:
	GameStatus.survival_timer_finished.emit()
