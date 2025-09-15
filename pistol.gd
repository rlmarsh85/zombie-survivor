extends Weapon

class_name Pistol

func _init() -> void:
	weapon_name = "pistol"
	cooldown_time = 0.3
	max_shots = 13
	reload_time = 1.5
	reload_size = max_shots
	is_automatic = false
	super()
	
func fire():
	
	muzzle_flash()
	
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_position = bullet_spawn_point.global_position
	bullet.rotation = self.rotation		
	
	super()


func _on_reload_timer_timeout() -> void:
	super()
