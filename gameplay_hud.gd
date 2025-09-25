extends Node2D

@onready var ammo_amount_label = $AmmoFacet/AmmoAmountLabel
@onready var stamina_progress = $StaminaFacet/StaminaProgressBar

var player : Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	stamina_progress.max_value = player.get_max_stamina()

func update_ammo_count() -> void:
	if player:
		ammo_amount_label.text = str(player.get_current_ammo()) + " / " + str(player.get_max_ammo())

func update_stamina_bar() -> void:
	if player:
		stamina_progress.value = player.get_current_stamina()
