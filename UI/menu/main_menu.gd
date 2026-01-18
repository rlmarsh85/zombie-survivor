extends ColorRect



func _on_quit_pressed() -> void:
	GameStatus.quit_game_pressed.emit()
