extends "res://singletons/weapon_service.gd"

onready var mod_tooltiptracking = get_tree().get_root().get_node("ModLoader/meinfesl-TooltipTrackingFix")

func spawn_projectile(
		rotation:float, 
		weapon_stats:RangedWeaponStats, 
		pos:Vector2, 
		knockback_direction:Vector2 = Vector2.ZERO, 
		deferred:bool = false, 
		effects:Array = [], 
		from:Node = null, 
		damage_tracking_key:String = ""
	)->Node:
	
	if damage_tracking_key == "" and mod_tooltiptracking.damage_tracking_key != "":
		damage_tracking_key = mod_tooltiptracking.damage_tracking_key
	return .spawn_projectile(rotation, weapon_stats, pos, knockback_direction, deferred, effects, from, damage_tracking_key)

func explode(effect:Effect, pos:Vector2, damage:int, accuracy:float, crit_chance:float, crit_dmg:float, burning_data:BurningData, is_healing:bool = false, ignored_objects:Array = [], damage_tracking_key:String = "")->Node:
	if damage_tracking_key == "" and mod_tooltiptracking.damage_tracking_key != "":
		damage_tracking_key = mod_tooltiptracking.damage_tracking_key
	return .explode(effect, pos, damage, accuracy, crit_chance, crit_dmg, burning_data, is_healing, ignored_objects, damage_tracking_key)
