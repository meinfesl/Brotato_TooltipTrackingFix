extends "res://entities/units/unit/unit.gd"

# Completely overrides base method
func _on_BurningTimer_timeout()->void :
	if _burning != null && _burning.type == BurningType.ENGINEERING:
		WeaponService.mod_tooltiptracking.damage_tracking_key = "item_turret_flame"
		
	._on_BurningTimer_timeout()
	
	if _burning != null && _burning.type == BurningType.ENGINEERING:
		WeaponService.mod_tooltiptracking.damage_tracking_key = ""


func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0)->Array:
	var dmg = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale)
	if WeaponService.mod_tooltiptracking.damage_tracking_key == "item_turret_flame":
		RunData.tracked_item_effects["item_turret_flame"] += dmg[1]
	return dmg


func _on_Hurtbox_area_entered(hitbox:Area2D)->void:
	WeaponService.mod_tooltiptracking.damage_tracking_key = hitbox.damage_tracking_key
	._on_Hurtbox_area_entered(hitbox)
	WeaponService.mod_tooltiptracking.damage_tracking_key  = ""
	
