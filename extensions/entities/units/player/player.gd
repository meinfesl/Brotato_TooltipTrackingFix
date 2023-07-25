extends "res://entities/units/player/player.gd"


func heal(value:int, is_from_torture:bool = false)->int:
	var amount_healed = .heal(value, is_from_torture) 
	if WeaponService.mod_tooltiptracking.damage_tracking_key != "":
		RunData.tracked_item_effects[WeaponService.mod_tooltiptracking.damage_tracking_key] += amount_healed
	return amount_healed


func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0, bypass_invincibility:bool = false)->Array:
	var reset = false
	var old = WeaponService.mod_tooltiptracking.damage_tracking_key
	if hitbox and hitbox.is_healing:
		WeaponService.mod_tooltiptracking.damage_tracking_key = hitbox.damage_tracking_key
		reset = true
		
	if RunData.effects["explode_on_hit"].size() > 0:
		var effect = RunData.effects["explode_on_hit"][0]
		WeaponService.mod_tooltiptracking.damage_tracking_key = effect.tracking_text
		reset = true
		
	var dmg = .take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale, bypass_invincibility)
	
	# Exploding is deferred but not sure if we can just use empty string here. Can take_damage be recursive? 
	if reset:
		WeaponService.mod_tooltiptracking.damage_tracking_key = old
		
	return dmg
