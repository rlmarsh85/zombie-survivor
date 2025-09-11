extends Node2D

class_name Weapon

var weapon_name : String
var is_shooting = false
var cooldown_time : float

@export var bullet_scene: PackedScene
@export var muzzle_scene: PackedScene

@onready var bullet_spawn_point = $BulletSpawnPoint
@onready var muzzle_flash_point = $MuzzleFlashPoint
@onready var cooldown_timer = $CooldownTimer


func _init() -> void:
	pass

func _ready() -> void:
	cooldown_timer.wait_time = cooldown_time
	
func muzzle_flash():
	var muzzle_flash = muzzle_scene.instantiate()
	add_child(muzzle_flash)
	muzzle_flash.global_position = muzzle_flash_point.global_position
	muzzle_flash.rotation = self.rotation


func is_ready():
	if(cooldown_timer.is_stopped()):
		return true
	
	return false
	
func fire():
	
	cooldown_timer.start()
	
func get_cooldown_time():
	return cooldown_time
	
func get_weapon_name():
	return weapon_name

func get_walk_animation():
	return "walk_" + weapon_name
	
func get_idle_animation():
	return "idle_" + weapon_name
	
func get_shoot_animation():
	return "shoot_" + weapon_name
