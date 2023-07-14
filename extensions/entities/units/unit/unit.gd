extends "res://entities/units/unit/unit.gd"

# Completely overrides base method
func _on_BurningTimer_timeout()->void :
	if _burning != null:
		var dmg_taken = take_damage(_burning.damage, null, false, false, Utils.get_rand_element(burn_sounds), 0.1)
		
		
		if RunData.effects["burn_chance"].chance > 0.0 and _burning.chance <= RunData.effects["burn_chance"].chance and _burning.damage == RunData.effects["burn_chance"].damage:
			RunData.tracked_item_effects["item_scared_sausage"] += dmg_taken[1]
		elif RunData.effects["burn_chance"].chance > 0.0:
			var nb_sausages = RunData.get_nb_item("item_scared_sausage")
			RunData.tracked_item_effects["item_scared_sausage"] += nb_sausages
		elif _burning.type == BurningType.ENGINEERING:							# ACTUAL
			RunData.tracked_item_effects["item_turret_flame"] += dmg_taken[1]	# CHANGES
		
		if _burning.from != null and is_instance_valid(_burning.from):
			_burning.from.on_weapon_hit_something(self, dmg_taken[1])
		
		_burning.duration -= 1
		if _burning.duration <= 0:
			_burning = null
			_burning_timer.stop()
			_burning_particles.emitting = false
			_burning_particles.deactivate_spread()
		elif _burning.spread <= 0:
			_burning_particles.deactivate_spread()

# Completely overrides base method
func _on_Hurtbox_area_entered(hitbox:Area2D)->void :
	
	if not hitbox.active or hitbox.ignored_objects.has(self):
		return 
	var dmg = hitbox.damage
	var dmg_taken = [0, 0]
	
	if hitbox.deals_damage:
		var is_exploding = false
		
		for effect in hitbox.effects:
			if effect is ExplodingEffect:
				if randf() < effect.chance:
					var explosion = WeaponService.explode(effect, global_position, hitbox.damage, hitbox.accuracy, hitbox.crit_chance, hitbox.crit_damage, hitbox.burning_data, hitbox.is_healing, [], hitbox.damage_tracking_key) # ACTUAL CHANGES
					
					if hitbox.from != null and is_instance_valid(hitbox.from):
						explosion.connect("hit_something", hitbox.from, "on_weapon_hit_something")
					
					is_exploding = true
		
		
		if not is_exploding:
			dmg_taken = take_damage(dmg, hitbox)
			
			if hitbox.burning_data != null and randf() < hitbox.burning_data.chance and not hitbox.is_healing:
				apply_burning(hitbox.burning_data)
		
		if hitbox.projectiles_on_hit.size() > 0:
			for i in hitbox.projectiles_on_hit[0]:
				var projectile = WeaponService.manage_special_spawn_projectile(
					self, 
					hitbox.projectiles_on_hit[1], 
					hitbox.projectiles_on_hit[2], 
					_entity_spawner_ref
				)
				projectile.connect("hit_something", hitbox.from, "on_weapon_hit_something")
				
				projectile.call_deferred("set_ignored_objects", [self])
		
		on_hurt()
	
	hitbox.hit_something(self, dmg_taken[1])
