extends Node2D

class_name Weapon

var weapon_name : String
var is_shooting = false

func get_weapon_name():
	return weapon_name

func get_walk_animation():
	return "walk_" + weapon_name
	
func get_idle_animation():
	return "idle_" + weapon_name
	
func get_shoot_animation():
	return "shoot_" + weapon_name
