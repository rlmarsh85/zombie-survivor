extends Control

class_name PauseMenu

func _ready() -> void:
	GameStatus.pause_closed_requested.connect(close_pause_menu)
	GameStatus.pause_open_requested.connect(open_pause_menu)
	
	if get_tree().current_scene == self:
		GameStatus.is_pause_available = true

func _input(event):
	if event.is_action_pressed("pause") && GameStatus.is_pause_available:
		if !visible:
			handle_pause()
			return
		
		if visible:
			handle_unpause()
			return
		


func handle_pause() -> void:
	visible = true
	get_tree().paused = true
	
func handle_unpause() -> void:
	visible = false
	get_tree().paused = false

func close_pause_menu() -> void:
	handle_unpause()
	
func open_pause_menu() -> void:
	self.visible = true


func _on_close_button_pressed() -> void:
	GameStatus.pause_closed_requested.emit()
