extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var zombie_sound_container: Node2D = $ZombieSounds

@onready var attack_sound: Node2D = $AttackSound

const WANDER_SPEED = 75
const RUN_SPEED = 250


const DeathEffect = preload("res://zombie_death.tscn")
const ATTACK_FRAME_INDEX = 6

@export var base_speed = 250

var player : Node2D


func _ready() -> void:
	animator.animation = "walk"
	animator.play()
	player = get_tree().get_first_node_in_group("player")
	
	play_zombie_sounds()
	set_speed(WANDER_SPEED)


func _physics_process(delta: float) -> void:
	if not player:
		return
	
	move_zombie()

func set_speed(new_speed : int):
	base_speed = new_speed

func move_zombie() -> void:
	if not player || player.is_dead:
		return
	
	navigation_agent.target_position = player.global_position
	var current_agent_position = global_position
	
	var direction: Vector2 = navigation_agent.get_next_path_position()
	
	rotation = global_position.direction_to(direction).angle()
	velocity = current_agent_position.direction_to(direction) * base_speed
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


func stop_moving():
	animator.animation = "idle"
	animator.play()
	velocity = Vector2.ZERO


func play_zombie_sounds():
	var sound = zombie_sound_container.get_children().pick_random()
	sound.play()


func _on_attack_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animator.animation = "attack"
		animator.play()
		attack_sound.play()


func _on_attack_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		animator.animation = "walk"
		animator.play()


func _on_alert_timer_timeout() -> void:
	set_speed(RUN_SPEED)
