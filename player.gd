extends CharacterBody2D

signal player_died

enum State { IDLE, WALKING }
const PISTOL_SCENE = preload("res://pistol.tscn")
const SHOTGUN_SCENE = preload("res://shotgun.tscn")
const RIFLE_SCENE = preload("res://rifle.tscn")

const WALK_SPEED = 200
const RUN_SPEED = 500

@onready var walk_sound: AudioStreamPlayer2D = $Footstep
@onready var death_sound: AudioStreamPlayer2D = $DeathSound


@export var speed = 200
@export var max_stamina = 6

@onready var weapon_container = $WeaponContainer
@onready var animator = $AnimatedSprite2D

@export var is_dead = true
var current_state = State.IDLE
var is_walking = false
var current_stamina

var weapons
var current_weapon : Weapon

var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	initialize_weapons()
	current_stamina = max_stamina


func initialize_weapons():
	weapons = [
		PISTOL_SCENE.instantiate(), 
		SHOTGUN_SCENE.instantiate(), 
		RIFLE_SCENE.instantiate()
	]
	current_weapon = weapons[0]
	for weapon in weapons:
		weapon_container.add_child(weapon)
			
func _physics_process(delta):
	look_at(get_global_mouse_position())
	set_direction(delta)
	
			
	if Input.is_action_pressed("reload"):
		current_weapon.reload()		
			
	if Input.is_action_pressed("shoot") && !Input.is_action_pressed("reload"):
		handle_shoot(true)	
		
	move_and_slide()
	
func _unhandled_input(event):

	if event.is_action_pressed("shoot"):
		handle_shoot(false)
	if event.is_action_pressed("switch_weapon"):
		rotate_weapon()
	
	if event.is_action_pressed("run"):
		setSpeed(RUN_SPEED)
	if event.is_action_released("run"):
		setSpeed(WALK_SPEED)


func setSpeed(new_speed):
	if(current_stamina > 0 || new_speed == WALK_SPEED):
		speed = new_speed
	
func rotate_weapon():

	if(current_weapon.is_shooting || is_dead || current_weapon.is_reloading):
		return
	
	for i in weapons.size():
		if(i == weapons.size() - 1):
			current_weapon = weapons[0]
			break			
			
		if(weapons[i].get_weapon_name() == current_weapon.get_weapon_name()):
			current_weapon = weapons[i + 1]
			break

		
func set_direction(delta):
	if is_dead:
		velocity = Vector2.ZERO
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	is_walking = direction != Vector2.ZERO
	if is_walking:
		velocity = direction * speed
		current_state = State.WALKING
		if(!walk_sound.is_playing()):
			walk_sound.play()
		
	else:
		current_state = State.IDLE
		velocity = Vector2.ZERO
		if(walk_sound.is_playing()):
			walk_sound.stop()
		
	handle_animation()

func handle_shoot(is_automatic = false) -> void:
	
	if(!current_weapon.is_ready(is_automatic) || is_dead):
		return
		
	current_weapon.fire()
	

func handle_animation():
	if current_weapon.is_shooting:
		animator.animation = current_weapon.get_shoot_animation()
	elif current_weapon.is_reloading:
		animator.animation = current_weapon.get_reload_animation()
	else:
		if is_walking:
			animator.animation = current_weapon.get_walk_animation()
		else:
			animator.animation = current_weapon.get_idle_animation()
	
	animator.play()
	
func gets_eaten() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	death_sound.play()
	is_dead = true
	hide()
	player_died.emit()	
	
func resurrect() -> void:
	is_dead = false
	current_stamina = max_stamina
	initialize_weapons()
	$CollisionShape2D.set_deferred("disabled", false)
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	
	if animator.animation == current_weapon.get_shoot_animation():
		current_weapon.is_shooting = false


func _on_rest_timer_timeout() -> void:
	if !Input.is_action_pressed("run") and current_stamina < max_stamina:
		current_stamina = current_stamina + 1


func _on_run_timer_timeout() -> void:
	if Input.is_action_pressed("run") and !current_stamina < 1:
		current_stamina = current_stamina - 1
	else:
		setSpeed(WALK_SPEED)
