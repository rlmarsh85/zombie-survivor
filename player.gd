extends CharacterBody2D

signal player_died

enum State { IDLE, WALKING }


@export var bullet_scene: PackedScene
@export var muzzle_scene: PackedScene
@export var speed = 600

# A reference to our spawn position marker.
@onready var bullet_spawn_point = $BulletSpawn
@onready var muzzle_flash_spawn_point = $MuzzleFlashSpawn
@onready var cooldown_timer = $CooldownTimer
@onready var animator = $AnimatedSprite2D

@export var is_dead = true
var current_state = State.IDLE
var is_walking = false
var is_shooting = false

var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
func _physics_process(delta):
	look_at(get_global_mouse_position())
	set_direction(delta)
	move_and_slide()
	
func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		handle_shoot(event)
		
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
	if(!cooldown_timer.is_stopped() || is_dead):
		return
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_spawn_point.global_position
	bullet.rotation = self.rotation	
	
	var muzzle_flash = muzzle_scene.instantiate()
	get_parent().add_child(muzzle_flash)
	muzzle_flash.global_position = muzzle_flash_spawn_point.global_position
	muzzle_flash.rotation = self.rotation
	
	is_shooting = true

	cooldown_timer.start()
	
func handle_animation():
	if is_shooting:
		animator.animation = "shoot_pistol"
	else:
		if is_walking:
			animator.animation = "walk_pistol"
		else:
			animator.animation = "idle_pistol"
	
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
	
	if animator.animation == "shoot_pistol":
		is_shooting = false
