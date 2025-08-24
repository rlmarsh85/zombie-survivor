extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

const DeathEffect = preload("res://zombie_death.tscn")
const ATTACK_FRAME_INDEX = 6

var base_speed = 150
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
	if not player || player.is_dead:
		return

	var direction = global_position.direction_to(player.global_position)
	rotation = direction.angle()
	velocity = direction * base_speed
	move_and_slide()		
	
func take_damage() -> void:
	var death_effect = DeathEffect.instantiate()
	get_parent().add_child(death_effect)
	death_effect.global_position = global_position
	death_effect.emitting = true
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == ATTACK_FRAME_INDEX:
		player.gets_eaten()


#func _on_attack_radius_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player"):
		#animator.animation = "attack"
		#animator.play()
#
#
#func _on_attack_radius_area_exited(area: Area2D) -> void:
	#if area.is_in_group("player"):
		#animator.animation = "walk"
		#animator.play()

func stop_moving():
	animator.animation = "idle"
	animator.play()
	velocity = Vector2.ZERO


func _on_attack_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animator.animation = "attack"
		animator.play()


func _on_attack_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		animator.animation = "walk"
		animator.play()
