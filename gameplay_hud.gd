extends Node2D

@onready var ammo_amount_label = $AmmoFacet/AmmoAmountLabel

var player : Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")

func update_ammo_count() -> void:
	if player:
		ammo_amount_label.text = str(player.get_current_ammo()) + " / " + str(player.get_max_ammo())
