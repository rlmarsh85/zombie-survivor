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
	spwanBullet(bullet_spawn_point.global_rotation)
	
	super()


func _on_reload_timer_timeout() -> void:
	super()
