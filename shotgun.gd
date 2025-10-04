extends Weapon

class_name Shotgun

@onready var cock_sound = $CockSound
@onready var bullet_spawn_point = $BulletSpawnPoint


func spwan_bullet(_custom_rotation=null):

	var angle_offset = -10  # Starting angle for the first bullet, to center the spread
	var angle_step = 6      # Angle between each bullet
	
	for i in range(6):
		
		var new_rotation = bullet_spawn_point.global_rotation + deg_to_rad(angle_offset)
		super(new_rotation)
		angle_offset += angle_step
	
	await get_tree().create_timer(0.3).timeout
	cock_sound.play()
