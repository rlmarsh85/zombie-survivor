extends Node


@export var zombie_spawaner: PackedScene
@onready var spawn_path = $SpawnBoundary/SpawnPath
@onready var player = $Player

func _on_spawn_timer_timeout() -> void:
	var zombie = zombie_spawaner.instantiate()
	
	# Pick a random spawn point along the path
	spawn_path.progress_ratio = randf()
	zombie.global_position = spawn_path.global_position
	
	# Add to the scene BEFORE calculating direction
	add_child(zombie)
	
	zombie.move_zombie()
