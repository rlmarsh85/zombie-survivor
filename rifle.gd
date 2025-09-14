extends Weapon

class_name Rifle

func _init() -> void:
	weapon_name = "rifle"
	cooldown_time = 0.2
	max_shots = 30
	reload_time = 3.0
	is_automatic = true
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
