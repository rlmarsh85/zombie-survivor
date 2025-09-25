extends Weapon

class_name Rifle

func _init() -> void:
	weapon_name = "rifle"
	cooldown_time = 0.2
	max_shots = 30
	reload_time = 3.0
	reload_size = max_shots
	is_automatic = true
	super()
	
func fire(is_automatic_fire = false):
	
	if(!check_is_ready(is_automatic_fire)):
		return 
		
	muzzle_flash()
	
	var bullet = bullet_scene.instantiate()	
	spwanBullet(bullet_spawn_point.global_rotation)	
	
	super()


func _on_reload_timer_timeout() -> void:
	super()
