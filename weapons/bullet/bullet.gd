extends Area2D


@export var speed = 1000.0

var velocity = Vector2.ZERO

func _ready():
	
	velocity = Vector2.from_angle(rotation) * speed
	
func _process(delta):
	
	position += velocity * delta

	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
	
	queue_free()
