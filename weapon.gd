extends Node2D

class_name Weapon

@export var stats : WeaponStats:
	set(new_stats):
		stats = new_stats
		if stats == null:
			return
			
		if not is_node_ready():
			await ready
		
signal finished_reloading


var is_shooting = false
var is_reloading = false
var current_shots : int

@onready var cooldown_timer = $CooldownTimer
@onready var reload_timer = $ReloadTimer
@onready var reload_sound = $ReloadSound
@onready var empty_sound = $EmptySound
@onready var bullet_spawn_location = $BulletSpawnPoint
@onready var muzzle_flash_location = $MuzzleFlashPoint

func _init() -> void:
	pass

func _ready() -> void:
	cooldown_timer.wait_time = stats.cooldown_time	
	reload_timer.wait_time = stats.reload_time
	reload_sound.stream = stats.reload_sound
	empty_sound.stream = stats.empty_sound
	current_shots = stats.max_shots
	bullet_spawn_location.position = stats.bullet_spawn_position
	muzzle_flash_location.position = stats.muzzle_flash_position
		
func muzzle_flash():
	var flash = stats.muzzle_scene.instantiate()
	add_child(flash)
	flash.global_position = muzzle_flash_location.global_position
	flash.rotation = self.rotation
	
func is_full():
	return current_shots == stats.max_shots

func reload():
	if !is_full() && not is_reloading:
		is_reloading = true
		reload_timer.start()
		reload_sound.play()
		
func is_ready(is_automatic_fire = false):

	if(is_automatic_fire && !stats.is_automatic):
		return false
	
	if(!cooldown_timer.is_stopped()):
		return false
	
	if(current_shots <= 0):
		empty_sound.play()
		return false
	
	if(is_reloading):
		return false
	
	return true
	
func fire(_is_automatic_fire = false):
	if(!is_ready(_is_automatic_fire)):
		return 
		
	muzzle_flash()
	spwan_bullet()			

	is_shooting = true
	cooldown_timer.start()
	current_shots = current_shots - 1
	
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = stats.shoot_sound
	add_child(sound_player)
	sound_player.play()
	sound_player.finished.connect(sound_player.queue_free)

	
func spwan_bullet(_custom_rotation=null):
	var bullet = stats.bullet_scene.instantiate()	
	bullet.global_position = bullet_spawn_location.global_position
	
	var final_rotation = bullet_spawn_location.global_rotation
	if _custom_rotation:
		final_rotation = _custom_rotation
		
	bullet.global_rotation = final_rotation
	get_tree().root.add_child(bullet)	

func get_current_ammo():
	return current_shots
	
func get_max_ammo():
	if stats && stats.max_shots:
		return stats.max_shots
	
func get_cooldown_time():
	return stats.cooldown_time
	
func get_weapon_name():
	return stats.weapon_name

func get_walk_animation():
	if(stats && stats.weapon_name):
		return "walk_" + stats.weapon_name
	
func get_idle_animation():
	if(stats && stats.weapon_name):
		return "idle_" + stats.weapon_name
	
func get_reload_animation():
	if(stats && stats.weapon_name):
		return "reload_" + stats.weapon_name	
	
func get_shoot_animation():
	if(stats && stats.weapon_name):
		return "shoot_" + stats.weapon_name

func _on_reload_timer_timeout() -> void:
	current_shots = min(current_shots + stats.reload_size, stats.max_shots)
	is_reloading = false
	finished_reloading.emit()
