extends GPUParticles2D

@onready var splatter_container: Node2D = $SplatterSounds

func _on_finished() -> void:
	queue_free()

func _on_draw() -> void:
	var sound = splatter_container.get_children().pick_random()
	#TODO: Sound effect kinda sucks, needs more anyways
	#sound.play()	
