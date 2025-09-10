extends Weapon

class_name Shotgun



func _init(specific_muzzle_spawn_point:Node2D, weapon_owner:Node2D) -> void:
	weapon_name = "shotgun"
	cooldown_time = 1.0
	super(specific_muzzle_spawn_point, weapon_owner)
	
