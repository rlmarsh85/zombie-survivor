extends Node


class_name DamageCalculator


func calculate_damage( damage_source: Node2D,  target: Node2D):
	var damage : DamageStats
	
	if(!damage_source.has_method("get_damage")):
		return
		
	if(!target.has_method("take_damage")):
		return
		
	damage = damage_source.get_damage()
	target.take_damage(damage.amount)
		
		
