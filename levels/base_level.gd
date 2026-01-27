extends Node


@export var zombie_spawaner: PackedScene
@onready var player = $Player
@onready var hud = $HUD/MenuHUD
@onready var gameplay_hud = $HUD/GameplayHUD

func _ready() -> void:
	player.hide()
	
	stop_spawning()
	hud.display_start_button()
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
