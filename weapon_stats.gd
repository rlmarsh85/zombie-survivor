extends Resource

class_name WeaponStats


@export var weapon_name : String
@export var cooldown_time : float
@export var max_shots : int
@export var reload_time : float
@export var is_automatic : bool
@export var reload_sound: AudioStream
@export var empty_sound: AudioStream

@export var muzzle_flash_position: Vector2
@export var bullet_spawn_position: Vector2

@export var bullet_scene: PackedScene
@export var muzzle_scene: PackedScene
@export var shoot_sound: AudioStream
