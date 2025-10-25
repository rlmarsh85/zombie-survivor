extends Node2D

@onready var ammo_amount_label = $AmmoFacet/AmmoAmountLabel
@onready var stamina_progress = $StaminaFacet/StaminaProgressBar

var player : Node2D

func _ready():
	GameStatus.connect("max_stamina_changed", set_stamina_bar_max)
	GameStatus.connect("ammo_updated", update_ammo_count)
	GameStatus.connect("stamina_updated", update_stamina_bar)
	
func set_stamina_bar_max(new_max_stamina) -> void:
	stamina_progress.max_value = new_max_stamina

func update_ammo_count(current_ammo, max_ammo) -> void:
	ammo_amount_label.text = str(current_ammo) + " / " + str(max_ammo)

func update_stamina_bar(new_stamina) -> void:
	stamina_progress.value = new_stamina
