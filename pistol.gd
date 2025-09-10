extends Weapon

class_name Pistol


func _init(specific_muzzle_spawn_point:Node2D, weapon_owner:Node2D) -> void:
	weapon_name = "pistol"
	cooldown_time = 0.3
	super(specific_muzzle_spawn_point, weapon_owner)
