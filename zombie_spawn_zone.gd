@tool 

extends Node2D 

@export var zombie_scene: PackedScene
@export var timer_duration: float = 1.0:
	set = set_wait_time_export
		
@export var shape_node_path: NodePath = "":
	set = set_shape_node_path
	
@export var min_enemies: int = 1
@export var max_enemies: int = 5

@onready var timer: Timer = $SpawnTimer 
@onready var internal_timer: Timer = $InternalTimer 
var collision_shape: CollisionShape2D
var rect_shape: RectangleShape2D
var half_extents: Vector2

		
func _ready() -> void:
	timer.wait_time = timer_duration
	
	if shape_node_path:
		_assign_shape_node()
		
func start_timer():
	timer.start()
	
func stop_timer():
	timer.stop()
func set_shape_node_path(path: NodePath):
	shape_node_path = path
	
	if is_inside_tree():
		_assign_shape_node()


func set_wait_time_export(value: float) -> void:
	timer_duration = value
   
	if is_inside_tree():
		timer.wait_time = value		

func _assign_shape_node():

	var shape_node = get_node_or_null(shape_node_path)

	if shape_node is CollisionShape2D:
		shape_node.reparent(self)
		collision_shape = shape_node
		rect_shape = collision_shape.shape
		half_extents = rect_shape.extents
	elif shape_node:
		push_warning("Shape Node must be a CollisionShape2D.")

func get_random_spawn_position() -> Vector2:
	
	var random_x = randf_range(-half_extents.x, half_extents.x)
	var random_y = randf_range(-half_extents.y, half_extents.y)
	var local_position = Vector2(random_x, random_y)

	var global =  collision_shape.to_global(local_position)
	return global


func spawn_wave():
	var num_enemies = randi_range(min_enemies, max_enemies)
	
	for i in range(num_enemies):
		spawn_enemy()
		#var wait_time = randf_range(0.02, 0.05)
		#internal_timer.wait_time = wait_time
		#internal_timer.start()


func spawn_enemy():
	var zombie = zombie_scene.instantiate()
	zombie.global_position = get_random_spawn_position()
	
	var target_parent = owner

	if target_parent == null:
		target_parent = self
			
	target_parent.add_child(zombie)
	zombie.move_zombie()	
