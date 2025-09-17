extends Weapon

class_name Shotgun

@onready var cock_sound = $CockSound

func _init() -> void:
	weapon_name = "shotgun"	
	cooldown_time = 1.0
	max_shots = 6
	reload_time = 1.0
	reload_size = 1
	is_automatic = false
	super()

	
func fire():
	var angle_offset = -10  # Starting angle for the first bullet, to center the spread
	var angle_step = 6      # Angle between each bullet
	muzzle_flash()
	
	for i in range(6):
		
		var new_rotation = bullet_spawn_point.global_rotation + deg_to_rad(angle_offset)
		spwanBullet(new_rotation)
		angle_offset += angle_step
	
	super()
	await get_tree().create_timer(0.3).timeout
	cock_sound.play()

func _on_reload_timer_timeout() -> void:
	super()
