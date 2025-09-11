extends CharacterBody2D

signal player_died

enum State { IDLE, WALKING }
const PISTOL_SCENE = preload("res://pistol.tscn")
const SHOTGUN_SCENE = preload("res://shotgun.tscn")


@export var speed = 600
@onready var weapon_container = $WeaponContainer
@onready var animator = $AnimatedSprite2D

@export var is_dead = true
var current_state = State.IDLE
var is_walking = false

var current_weapon : Weapon

var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	current_weapon =  PISTOL_SCENE.instantiate()
	weapon_container.add_child(current_weapon)
	
func _physics_process(delta):
	look_at(get_global_mouse_position())
	set_direction(delta)
	move_and_slide()
	
func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		handle_shoot(event)
	if event.is_action_pressed("switch_weapon"):
		rotate_weapon()

func rotate_weapon():

	if(current_weapon.is_shooting || is_dead):
		return
		
	if(current_weapon is Pistol ):
		current_weapon.queue_free()
		current_weapon =  SHOTGUN_SCENE.instantiate()		
	else:
		current_weapon.queue_free()
		current_weapon =  PISTOL_SCENE.instantiate()
		
	weapon_container.add_child(current_weapon)
		
func set_direction(delta):
	if is_dead:
		velocity = Vector2.ZERO
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	is_walking = direction != Vector2.ZERO
	if is_walking:
		velocity = direction * speed
		current_state = State.WALKING
		
	else:
		current_state = State.IDLE
		velocity = Vector2.ZERO
		
	handle_animation()

func handle_shoot(event) -> void:
	
	if(!current_weapon.is_ready() || is_dead):
		return
		
	current_weapon.fire()
	

func handle_animation():
	if current_weapon.is_shooting:
		animator.animation = current_weapon.get_shoot_animation()
	else:
		if is_walking:
			animator.animation = current_weapon.get_walk_animation()
		else:
			animator.animation = current_weapon.get_idle_animation()
	
	animator.play()
	
func gets_eaten() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	is_dead = true
	hide()
	player_died.emit()	
	
func resurrect() -> void:
	is_dead = false
	$CollisionShape2D.set_deferred("disabled", false)
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	pass
	if animator.animation == current_weapon.get_shoot_animation():
		current_weapon.is_shooting = false
