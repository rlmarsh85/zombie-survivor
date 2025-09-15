extends Node2D

class_name Weapon

var weapon_name : String
var is_shooting = false
var is_reloading = false
var cooldown_time : float

var max_shots : int
var current_shots : int
var reload_time : float
var is_automatic : bool
var reload_size: int

@export var bullet_scene: PackedScene
@export var muzzle_scene: PackedScene
@export var shoot_sound: AudioStream

@onready var bullet_spawn_point = $BulletSpawnPoint
@onready var muzzle_flash_point = $MuzzleFlashPoint
@onready var cooldown_timer = $CooldownTimer
@onready var reload_timer = $ReloadTimer
@onready var reload_sound = $ReloadSound


func _init() -> void:
	current_shots = max_shots

func _ready() -> void:
	cooldown_timer.wait_time = cooldown_time
	reload_timer.wait_time = reload_time
	
func muzzle_flash():
	var muzzle_flash = muzzle_scene.instantiate()
	add_child(muzzle_flash)
	muzzle_flash.global_position = muzzle_flash_point.global_position
	muzzle_flash.rotation = self.rotation
	
func is_full():
	return current_shots == max_shots

func reload():
	if !is_full() && not is_reloading:
		is_reloading = true
		reload_timer.start()
		reload_sound.play()

func is_ready(is_automatic_fire = false):
	
	if(is_automatic_fire && !is_automatic):
		return false
	
	if(!cooldown_timer.is_stopped()):
		return false
	
	if(current_shots <= 0):
		return false
	
	if(is_reloading):
		return false
	
	return true
	
func fire():
	
	is_shooting = true
	cooldown_timer.start()
	current_shots = current_shots - 1
	
	var sound_player = AudioStreamPlayer.new()
	sound_player.stream = shoot_sound
	add_child(sound_player)
	sound_player.play()
	sound_player.finished.connect(sound_player.queue_free)
	
	
func get_cooldown_time():
	return cooldown_time
	
func get_weapon_name():
	return weapon_name

func get_walk_animation():
	return "walk_" + weapon_name
	
func get_idle_animation():
	return "idle_" + weapon_name
	
func get_reload_animation():
	return "reload_" + weapon_name	
	
func get_shoot_animation():
	return "shoot_" + weapon_name

func _on_reload_timer_timeout() -> void:
	is_reloading = false
	current_shots = min(current_shots + reload_size, max_shots)
