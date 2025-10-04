extends Control


@onready var muzzle_pos: Node2D = $MuzzleFlashPoint
@onready var bullet_pos: Node2D = $BulletSpawnPoint



func _process(delta):

	print("Muzzle Position: ", muzzle_pos.global_position)
	print("Bullet Position: ", bullet_pos.rotation)
