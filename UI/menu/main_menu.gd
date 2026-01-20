extends ColorRect



func _on_quit_pressed() -> void:
	GameStatus.quit_game_pressed.emit()


func _on_new_game_pressed() -> void:
	GameStatus.new_game_pressed.emit()
