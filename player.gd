extends Area2D

signal player_died

@export var bullet_scene: PackedScene
@export var muzzle_scene: PackedScene
@export var speed = 600

# A reference to our spawn position marker.
@onready var bullet_spawn_point = $BulletSpawn
@onready var muzzle_flash_spawn_point = $MuzzleFlashSpawn
@onready var cooldown_timer = $CooldownTimer

@export var is_dead = false
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	set_direction(delta)
	
func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		handle_shoot(event)
	
func set_direction(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if(Input.is_action_pressed("left")):
		velocity.x -= 1
		
	if(Input.is_action_pressed("right")):
		velocity.x += 1
		
	if(Input.is_action_pressed("up")):
		velocity.y -= 1
		
	if(Input.is_action_pressed("down")):
		velocity.y += 1						
		
	if(velocity.length() > 0):
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "walk"		


func handle_shoot(event) -> void:
	if(!cooldown_timer.is_stopped()):
		return
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = bullet_spawn_point.global_position
	bullet.rotation = self.rotation	
	
	var muzzle_flash = muzzle_scene.instantiate()
	get_parent().add_child(muzzle_flash)
	muzzle_flash.global_position = muzzle_flash_spawn_point.global_position
	muzzle_flash.rotation = self.rotation
	
	cooldown_timer.start()
	
func gets_eaten() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	is_dead = true
	hide()
	player_died.emit()	
	
