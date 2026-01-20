extends Control


func _ready() -> void:
	GameStatus.close_options_pressed.connect(close_self)


func _on_close_button_pressed() -> void:
	GameStatus.close_options_pressed.emit()


func close_self() -> void:
	visible = false
	
func open_self() -> void:
	visible = true
