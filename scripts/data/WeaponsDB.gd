extends Node


class_name WeaponDB

const GENERIC_WEAPON_SCENE = preload("res://weapon.tscn")
const SHOTGUN_SCENE = preload("res://shotgun.tscn")


const WEAPONS = [
	{
		"scene": GENERIC_WEAPON_SCENE, 
		"stats_path": "res://resources/weapons/pistol.tres"
	},
	{
		"scene": SHOTGUN_SCENE, 
		"stats_path": "res://resources/weapons/shotgun.tres"
	},
	{
		"scene": GENERIC_WEAPON_SCENE, 
		"stats_path": "res://resources/weapons/rifle.tres"
	}
]
