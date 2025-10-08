extends Node


class_name DamageCalculator


func calculate_damage( damage_source: Node2D,  target: Node2D):
	var damage : DamageStats
	var resistences : ResistenceStats
	var resisted_damage : float
	
	
	if(!damage_source.has_method("get_damage")):
		return
		
	if(!target.has_method("take_damage")):
		return
	
	if(target.has_method("get_resistences")):
		resistences = target.get_resistences()
	else:
		resistences = Constants.get_default_resistences()
		
		
	damage = damage_source.get_damage()
	resisted_damage = round(damage.amount * resistences.resistences[damage.type])
	
	target.take_damage(resisted_damage)
		
		
