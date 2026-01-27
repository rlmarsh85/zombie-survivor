extends ColorRect

@onready var instructions_menu : InstructionsMenu = %HowToPlay
@onready var options_menu : OptionsMenu = %OptionsMenu


func open_instructions() -> void:
	instructions_menu.open_instructions()
	
func open_options() -> void:
	options_menu.open_options_menu()

func _on_quit_pressed() -> void:
	GameStatus.quit_game_pressed.emit()


func _on_new_game_pressed() -> void:
	GameStatus.new_game_pressed.emit()
