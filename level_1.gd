extends Node


@export var zombie_spawaner: PackedScene
@onready var spawn_path = $SpawnBoundary/SpawnPath
@onready var player = $Player
@onready var spawnZone = $ZombieSpawnZone
@onready var hud = $HUD/MenuHUD
@onready var gameplay_hud = $HUD/GameplayHUD

func _ready() -> void:
	player.hide()
	
	spawnZone.stop_timer()
	hud.display_start_button()
	gameplay_hud.visible = false


func _on_player_player_died() -> void:
	spawnZone.stop_timer()
	get_tree().call_group("enemies", "stop_moving")
	hud.restart_display()


func _on_hud_go_button_pressed() -> void:	
	get_tree().call_group("enemies", "queue_free")
	player.resurrect()
	hud.hide_display()
	gameplay_hud.visible = true
	player.show()
	spawnZone.start_timer()
