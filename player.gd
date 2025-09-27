extends CharacterBody2D

signal player_died
signal weapon_changed
signal fired_weapon
signal weapon_reloaded
signal stamina_changed

enum State { IDLE, WALKING }
const PISTOL_SCENE = preload("res://pistol.tscn")
const SHOTGUN_SCENE = preload("res://shotgun.tscn")
const RIFLE_SCENE = preload("res://rifle.tscn")

const WALK_SPEED = 200
const RUN_SPEED = 500
const KNIFE_ATTACK_ANIMATION_NAME = "attack_knife"
const MINIMUM_KNIFE_STAMINA = 0.5
const MAXIMUM_KNIFE_VICTIMS = 2

@onready var walk_sound: AudioStreamPlayer2D = $Footstep
@onready var death_sound: AudioStreamPlayer2D = $DeathSound


@export var speed = 200
@export var max_stamina = 6
@export var stamina_step_size = 0.1

@onready var weapon_container = $WeaponContainer
@onready var animator = $AnimatedSprite2D

@export var is_dead = true
var current_state = State.IDLE
var is_walking = false

var is_knife_attacking = false

var current_knife_victims = 0

var current_stamina

var weapons
var current_weapon : Weapon

var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	initialize_weapons()		
	set_new_stamina(max_stamina, false)

func initialize_weapons():
	weapons = [
		PISTOL_SCENE.instantiate(), 
		SHOTGUN_SCENE.instantiate(), 
		RIFLE_SCENE.instantiate()
	]
	current_weapon = weapons[0]
	for weapon in weapons:
		weapon_container.add_child(weapon)
		weapon.finished_reloading.connect(weapon_finished_reloading)
	
	weapon_changed.emit()
	
func _physics_process(_delta):
	look_at(get_global_mouse_position())
	set_direction()
	
			
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
		
	if event.is_action_pressed("knife_attack"):
		knife_attack()


func setSpeed(new_speed):
	if(current_stamina > 0 || new_speed == WALK_SPEED):
		speed = new_speed
		
func set_new_stamina(new_stamina_value, should_signal = true):
	current_stamina = new_stamina_value
	if(should_signal):
		stamina_changed.emit()		

func get_current_stamina():
	return current_stamina
	
func get_max_stamina():
	return max_stamina	
	
func set_is_knife_attack(new_knife_attacking):	
	is_knife_attacking = new_knife_attacking
	if(is_knife_attacking):
		current_knife_victims = 0
		

func knife_attack():
	
	if(
		!current_weapon.is_reloading && 
		!is_knife_attacking && 
		current_stamina > MINIMUM_KNIFE_STAMINA
	):
		set_is_knife_attack(true)
	
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

	weapon_changed.emit()
	
func set_direction():
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

func handle_shoot(is_automatic_fire = false) -> void:
	
	if(is_dead || is_knife_attacking):
		return
		
	current_weapon.fire(is_automatic_fire)
	fired_weapon.emit()
	

func handle_animation():
	if current_weapon.is_shooting:
		animator.animation = current_weapon.get_shoot_animation()
	elif current_weapon.is_reloading:
		animator.animation = current_weapon.get_reload_animation()
	elif is_knife_attacking:
		animator.animation = KNIFE_ATTACK_ANIMATION_NAME
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
	set_new_stamina(max_stamina)
	initialize_weapons()
	$CollisionShape2D.set_deferred("disabled", false)
	
func get_current_ammo():
	return current_weapon.get_current_ammo()
	
func get_max_ammo():
	return current_weapon.get_max_ammo()
		
func _on_animated_sprite_2d_animation_finished() -> void:
	
	if animator.animation == current_weapon.get_shoot_animation():
		current_weapon.is_shooting = false
		return
		
	if animator.animation == KNIFE_ATTACK_ANIMATION_NAME:		
		set_is_knife_attack(false)
		return		


func _on_rest_timer_timeout() -> void:
	if !Input.is_action_pressed("run") and current_stamina < max_stamina:
		set_new_stamina(current_stamina + stamina_step_size)


func _on_run_timer_timeout() -> void:
	if Input.is_action_pressed("run") and !current_stamina < stamina_step_size:
		set_new_stamina(current_stamina - stamina_step_size)
	else:
		setSpeed(WALK_SPEED)
		
	if is_knife_attacking:
		set_new_stamina(current_stamina - stamina_step_size * 2)
		
func weapon_finished_reloading():
	weapon_reloaded.emit()		


func _on_knife_attack_range_body_entered(body: Node2D) -> void:
	if (
		is_knife_attacking && 
		body.has_method("take_damage") &&
		current_knife_victims < MAXIMUM_KNIFE_VICTIMS
	):
		current_knife_victims += 1
		body.take_damage()
	
