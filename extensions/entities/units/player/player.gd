extends "res://entities/units/player/player.gd"

# Completely overrides base method
func take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0, bypass_invincibility:bool = false)->Array:
	
	if hitbox and hitbox.is_healing:
		var _healed = on_healing_effect(value, hitbox.damage_tracking_key) # ACTUAL CHANGES
	elif _invincibility_timer.is_stopped() or bypass_invincibility:
		var dmg_taken = _unit_take_damage(value, hitbox, dodgeable, armor_applied, custom_sound, base_effect_scale) # ACTUAL CHANGES
		
		
		if dmg_taken[2]:
			if RunData.effects["dmg_on_dodge"].size() > 0 and hitbox != null and hitbox.from != null and is_instance_valid(hitbox.from):
				var total_dmg_to_deal = 0
				for dmg_on_dodge in RunData.effects["dmg_on_dodge"]:
					if randf() >= dmg_on_dodge[2] / 100.0:
						continue
					var dmg_from_stat = max(1, (dmg_on_dodge[1] / 100.0) * Utils.get_stat(dmg_on_dodge[0]))
					var dmg = RunData.get_dmg(dmg_from_stat) as int
					total_dmg_to_deal += dmg
				var dmg_dealt = hitbox.from.take_damage(total_dmg_to_deal)
				RunData.tracked_item_effects["item_riposte"] += dmg_dealt[1]
			
			if RunData.effects["heal_on_dodge"].size() > 0:
				var total_to_heal = 0
				for heal_on_dodge in RunData.effects["heal_on_dodge"]:
					if randf() < heal_on_dodge[2] / 100.0:
						total_to_heal += heal_on_dodge[1]
				var _healed = on_healing_effect(total_to_heal, "item_adrenaline", false)
			
			if RunData.effects["temp_stats_on_dodge"].size() > 0:
				for temp_stat_on_hit in RunData.effects["temp_stats_on_dodge"]:
					TempStats.add_stat(temp_stat_on_hit[0], temp_stat_on_hit[1])
		
		if dmg_taken[1] > 0 and consumables_in_range.size() > 0:
			for cons in consumables_in_range:
				cons.attracted_by = self
		
		if dodgeable:
			disable_hurtbox()
			_invincibility_timer.start(get_iframes(dmg_taken[1]))
		
		if dmg_taken[1] > 0:
			if RunData.effects["explode_on_hit"].size() > 0:
				var effect = RunData.effects["explode_on_hit"][0]
				var stats = _explode_on_hit_stats
				var _inst = WeaponService.explode(effect, global_position, stats.damage, stats.accuracy, stats.crit_chance, stats.crit_damage, stats.burning_data, false, [], effect.tracking_text)
			
			if RunData.effects["temp_stats_on_hit"].size() > 0:
				for temp_stat_on_hit in RunData.effects["temp_stats_on_hit"]:
					TempStats.add_stat(temp_stat_on_hit[0], temp_stat_on_hit[1])
			
			check_hp_regen()
		
		return dmg_taken
	
	return [0, 0]

# Total copy of Unit::take_damage because can't call it directly.
# Using .take_damage will call original Player::take_damage 
func _unit_take_damage(value:int, hitbox:Hitbox = null, dodgeable:bool = true, armor_applied:bool = true, custom_sound:Resource = null, base_effect_scale:float = 1.0)->Array:
	if dead:
		return [0, 0]
	
	var crit_damage = 0.0
	var crit_chance = 0.0
	var knockback_direction = Vector2.ZERO
	var knockback_amount = 0.0
	var effect_scale = base_effect_scale
	var dmg_dealt = 0
	
	if hitbox != null:
		crit_damage = hitbox.crit_damage
		crit_chance = hitbox.crit_chance
		knockback_direction = hitbox.knockback_direction
		knockback_amount = hitbox.knockback_amount
		effect_scale = hitbox.effect_scale
	
	var is_crit = false
	var is_miss = false
	var is_dodge = false
	var is_protected = false

	var full_dmg_value = get_dmg_value(value, armor_applied)
	



	if dodgeable and randf() < min(current_stats.dodge, RunData.effects["dodge_cap"] / 100.0):
		full_dmg_value = 0
		is_dodge = true
	elif _hit_protection > 0:
		_hit_protection -= 1
		full_dmg_value = 0
		is_protected = true
	else :
		flash()
	
	var sound = Utils.get_rand_element(hurt_sounds)
	
	if full_dmg_value == 0:
		sound = Utils.get_rand_element(dodge_sounds)
	elif not is_miss and randf() < crit_chance:
		
		full_dmg_value = get_dmg_value(round(value * crit_damage) as int, true, true)
		
		dmg_dealt = clamp(full_dmg_value, 0, current_stats.health)
		
		if hitbox:
			hitbox.critically_hit_something(self, dmg_dealt)
		
		is_crit = true
		sound = Utils.get_rand_element(crit_sounds)
	
	if custom_sound:
		sound = custom_sound
	
	SoundManager2D.play(sound, global_position, 0, 0.2, always_play_hurt_sound)
	
	dmg_dealt = clamp(full_dmg_value, 0, current_stats.health)
	current_stats.health = max(0.0, current_stats.health - full_dmg_value) as int
	
	_knockback_vector = knockback_direction * knockback_amount
	
	emit_signal("health_updated", current_stats.health, max_stats.health)
	
	var hit_type = HitType.NORMAL
	
	if current_stats.health <= 0:
		if hitbox:
			hitbox.killed_something(self)
		die(knockback_direction * max(knockback_amount, MIN_DEATH_KNOCKBACK_AMOUNT))
		
		if is_crit:
			var gold_added = 0
			
			for effect in RunData.effects["gold_on_crit_kill"]:
				if randf() <= effect[1] / 100.0:
					gold_added += 1
					RunData.tracked_item_effects["item_hunting_trophy"] += 1
			
			if RunData.effects["heal_on_crit_kill"] > 0:
				if randf() <= RunData.effects["heal_on_crit_kill"] / 100.0:
					RunData.emit_signal("healing_effect", 1, "item_tentacle")
			
			for effect in hitbox.effects:
				if effect.key == "gold_on_crit_kill" and randf() <= effect.value / 100.0:
					gold_added += 1
					hitbox.added_gold_on_crit(gold_added)
			
			if gold_added > 0:
				RunData.add_gold(gold_added)
				hit_type = HitType.GOLD_ON_CRIT_KILL
	
	emit_signal(
		"took_damage", 
		self, 
		full_dmg_value, 
		knockback_direction, 
		knockback_amount, 
		is_crit, 
		is_miss, 
		is_dodge, 
		is_protected, 
		effect_scale, 
		hit_type
	)
	
	return [full_dmg_value, dmg_dealt, is_dodge]
