extends Node2D


enum DAMAGE_TYPES {ZOMBIE_BITE, PLAYER_BULLETS, FIRE}

var DEFAULT_RESISTENCES: ResistenceStats = preload("res://data/resistences/default_resistences.tres")


func get_default_resistences() -> ResistenceStats:
	return DEFAULT_RESISTENCES
