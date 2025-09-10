extends Weapon

class_name Shotgun


func _init(specific_muzzle_spawn_point:Node2D, weapon_owner:Node2D) -> void:
	weapon_name = "shotgun"
	cooldown_time = 1.0
	super(specific_muzzle_spawn_point, weapon_owner)
	
func fire(bullet_scene,bullet_spawn_point):

	var angle_offset = -10  # Starting angle for the first bullet, to center the spread
	var angle_step = 2      # Angle between each bullet

	for i in range(6):
		var bullet = bullet_scene.instantiate()
		player.add_child(bullet)
		bullet.global_position = bullet_spawn_point.global_position

		var new_rotation = self.rotation + deg_to_rad(angle_offset)

		bullet.rotation = new_rotation
		angle_offset += angle_step
