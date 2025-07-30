extends Node2D


@export var speed = 1000.0

func _process(delta):
	var velocity = Vector2.ZERO
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * speed * delta

	
	
