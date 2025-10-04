extends Node


class_name WeaponDB

const GENERIC_WEAPON_SCENE = preload("res://weapons/common/weapon.tscn")
const SHOTGUN_SCENE = preload("res://weapons/shotgun/shotgun.tscn")


const WEAPONS = [
	{
		"scene": GENERIC_WEAPON_SCENE, 
		"stats_path": "res://weapons/resources/pistol.tres"
	},
	{
		"scene": SHOTGUN_SCENE, 
		"stats_path": "res://weapons/resources/shotgun.tres"
	},
	{
		"scene": GENERIC_WEAPON_SCENE, 
		"stats_path": "res://weapons/resources/rifle.tres"
	}
]
