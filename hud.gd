extends CanvasLayer

signal go_button_pressed

@onready var message = $Message
@onready var button = $Button

func _ready() -> void:
	message.hide()
	button.hide()
	
func display_start_button() -> void:
	button.text = "Start Game"
	button.show()

func display_restart_button() -> void:
	button.text = "Restart"
	button.show()


func restart_display() -> void:
	display_message("Game Over")
	display_restart_button()

func display_message (str: String) -> void:
	message.text = str
	message.show()
	
func hide_display() -> void:
	message.hide()
	button.hide()


func _on_button_pressed() -> void:
	go_button_pressed.emit()
