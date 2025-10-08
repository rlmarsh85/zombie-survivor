extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var zombie_sound_container: Node2D = $ZombieSounds
@onready var bite_hit_box_collision: CollisionShape2D = $BiteHitbox/BiteHitBoxCollision 
@onready var attack_sound: Node2D = $AttackSound

const WANDER_SPEED = 75
const BASE_RUN_SPEED = 250


const DeathEffect = preload("res://enemies/normal_zombie/effects/zombie_death.tscn")
const ATTACK_FRAME_INDEX = 6

@export var base_speed : int
@export var damage : DamageStats
@export var max_health : int = 25
var current_health: int

var player : Node2D

const PATHFINDING_SKIP_FRAMES = 10
var frame_counter = 0
var current_target_point: Vector2 


var wobble_time: float
#@export var wobble_strength: float = 0.15  # Max angle offset in radians (about 8.6 degrees)
#@export var wobble_speed: float = 5.0      # How fast the wobble changes (per second)

@export var wobble_strength: float = randf_range(0.05, 0.35)  # Max angle offset in radians (about 8.6 degrees)
@export var wobble_speed: float = randf_range(2.0,7.0)      # How fast the wobble changes (per second)



func _ready() -> void:
	animator.animation = "walk"
	animator.play()
	player = get_tree().get_first_node_in_group("player")
	
	play_zombie_sounds()
	set_speed(WANDER_SPEED)
	current_health = max_health


func _physics_process(_delta: float) -> void:
	if not player:
		return
	
	move_zombie(_delta)

func set_speed(new_speed : int):
	base_speed = new_speed
	
func move_zombie(delta) -> void:
	if not player or player.is_dead:
		return

	frame_counter += 1
	if frame_counter >= PATHFINDING_SKIP_FRAMES:
		navigation_agent.target_position = player.global_position
		frame_counter = 0


	current_target_point = navigation_agent.get_next_path_position()

	var direction_to_point = global_position.direction_to(current_target_point)

	if global_position.distance_to(current_target_point) > navigation_agent.radius:
		velocity = direction_to_point * base_speed
	else:
		velocity = Vector2.ZERO
		
	wobble_time += delta * wobble_speed
	var wobble_angle = sin(wobble_time) * wobble_strength
	velocity = velocity.rotated(wobble_angle)

	rotation = velocity.angle()
	move_and_slide()
	
func set_new_health(new_health : int) -> void:
	current_health = new_health
	
func take_damage(damage_amount : int) -> void:
	set_new_health(current_health - damage_amount)
	if(current_health <= 0):
		zombie_dies()

func zombie_dies() -> void:			
	var death_effect = DeathEffect.instantiate()
	
	get_parent().add_child(death_effect)
	death_effect.global_position = global_position
	death_effect.emitting = true
		
	queue_free()
	
func get_damage() -> DamageStats:
	return damage	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame == ATTACK_FRAME_INDEX:
		bite_hit_box_collision.disabled = false
		await get_tree().create_timer(0.1).timeout
		bite_hit_box_collision.disabled = true		
		


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
	var speed_factor = randf_range(0.6, 1.1)
	set_speed(BASE_RUN_SPEED * speed_factor)


func deal_damage(area: Area2D) -> void:
	DamageCalc.calculate_damage(self, area.owner)
