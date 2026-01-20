extends ColorRect

@onready var instructions_menu : Control = %HowToPlay
@onready var options_menu : Control = %OptionsMenu

func _ready() -> void:
	GameStatus.open_instructions_pressed.connect(open_instructions)
	GameStatus.open_options_pressed.connect(open_options)

func open_instructions() -> void:
	instructions_menu.open_self()
	
func open_options() -> void:
	options_menu.open_self()

func _on_quit_pressed() -> void:
	GameStatus.quit_game_pressed.emit()


func _on_new_game_pressed() -> void:
	GameStatus.new_game_pressed.emit()


func _on_how_to_play_pressed() -> void:
	GameStatus.open_instructions_pressed.emit()


func _on_options_pressed() -> void:
	GameStatus.open_options_pressed.emit()
