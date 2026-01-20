extends CanvasLayer

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var fader : ColorRect = $Fader

const SCENE_NAME_LEVEL_1 = "res://levels/level1/level_1.tscn"

func _ready() -> void:
	#fader.modulate.a = 0
	fader.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene(target_path: String) -> void:
	fader.mouse_filter = Control.MOUSE_FILTER_STOP
	
	animation_player.play("dissolve")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(target_path)
	
	animation_player.play_backwards("dissolve")
	await animation_player.animation_finished
	
	fader.mouse_filter = Control.MOUSE_FILTER_IGNORE
