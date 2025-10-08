extends Area2D


@export var speed = 1000.0
@export var damage: DamageStats

var velocity = Vector2.ZERO

func _ready():
	
	velocity = Vector2.from_angle(rotation) * speed
	
func _process(delta):	
	position += velocity * delta

func get_damage() -> DamageStats:
	return damage		

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("damagable"):
		var target : Node2D = body.owner
		if(!body.owner):
			target = body
		DamageCalc.calculate_damage(self, target)
	
	queue_free()
