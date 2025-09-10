extends Node2D

class_name Weapon

var weapon_name : String
var is_shooting = false
var cooldown_time : float
var muzzle_spawn_point : Node2D
var player : Node2D

func _init(specific_muzzle_spawn_point:Node2D, weapon_owner:Node2D) -> void:
	muzzle_spawn_point = specific_muzzle_spawn_point
	player = weapon_owner
	
func muzzle_flash(muzzle_scene):
	var muzzle_flash = muzzle_scene.instantiate()
	player.add_child(muzzle_flash)
	muzzle_flash.global_position = get_muzzle_spawn_point().global_position
	muzzle_flash.rotation = self.rotation
	
func get_muzzle_spawn_point():
	return muzzle_spawn_point
	
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
