extends Weapon

class_name Pistol


func _init(specific_muzzle_spawn_point:Node2D, weapon_owner:Node2D) -> void:
	weapon_name = "pistol"
	cooldown_time = 0.3
	super(specific_muzzle_spawn_point, weapon_owner)
	
func fire(bullet_scene,bullet_spawn_point):
	var bullet = bullet_scene.instantiate()
	player.add_child(bullet)
	bullet.global_position = bullet_spawn_point.global_position
	bullet.rotation = self.rotation		
