extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

var player : Node2D


func _ready() -> void:
	animator.animation = "walk"
	animator.play()
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if not player:
		return
	
	move_zombie()

func move_zombie() -> void:
	if not player:
		return

	var direction = global_position.direction_to(player.global_position)
	rotation = direction.angle()
	velocity = direction * 150
	move_and_slide()		

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
