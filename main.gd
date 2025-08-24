extends Node


@export var zombie_spawaner: PackedScene
@onready var spawn_path = $SpawnBoundary/SpawnPath
@onready var player = $Player
@onready var spawnTimer = $SpawnTimer
@onready var hud = $HUD

func _ready() -> void:
	player.hide()
	spawnTimer.stop()
	hud.display_start_button()

func _on_spawn_timer_timeout() -> void:
	var zombie = zombie_spawaner.instantiate()
	
	# Pick a random spawn point along the path
	spawn_path.progress_ratio = randf()
	zombie.global_position = spawn_path.global_position
	
	# Add to the scene BEFORE calculating direction
	add_child(zombie)
	
	zombie.move_zombie()


func _on_player_player_died() -> void:
	spawnTimer.stop()
	get_tree().call_group("enemies", "stop_moving")
	hud.restart_display()


func _on_hud_go_button_pressed() -> void:
	
	get_tree().call_group("enemies", "queue_free")
	player.is_dead = false
		
	hud.hide_display()
	player.show()
	spawnTimer.start()
