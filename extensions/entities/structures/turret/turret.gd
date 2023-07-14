extends "res://entities/structures/turret/turret.gd"

var damage_tracking_key = ""

func _ready():
	._ready()

	var path = self.get_path()
	var turret_name = path.get_name(path.get_name_count() - 1);
	
	if turret_name.begins_with("@"):
		turret_name = turret_name.substr(1)
	
	if turret_name.begins_with("Turret"):
		damage_tracking_key = "item_turret"
	elif turret_name.begins_with("FlameTurret"):
		damage_tracking_key = "item_turret_flame"
	elif turret_name.begins_with("LaserTurret"):
		damage_tracking_key = "item_turret_laser"
	elif turret_name.begins_with("RocketTurret"):
		damage_tracking_key = "item_turret_rocket"
	elif turret_name.begins_with("Tyler"):
		damage_tracking_key = "item_tyler"
	elif turret_name.begins_with("HealingTurret"):
		damage_tracking_key = "item_turret_healing"

# Completely overrides base method
func shoot()->void :
	if _current_target.size() == 0 or not is_instance_valid(_current_target[0]):
		_is_shooting = false
		_cooldown = rand_range(max(1, _max_cooldown * 0.7), _max_cooldown * 1.3)
	else :
		_next_proj_rotation = (_current_target[0].global_position - global_position).angle()
	
	SoundManager2D.play(Utils.get_rand_element(stats.shooting_sounds), global_position, stats.sound_db_mod, 0.2)
	
	for i in stats.nb_projectiles:
		var proj_rotation = rand_range(_next_proj_rotation - stats.projectile_spread, _next_proj_rotation + stats.projectile_spread)
		var knockback_direction: = - Vector2(cos(proj_rotation), sin(proj_rotation))
		
		# ACTUAL CHANGES
		var _projectile = WeaponService.spawn_projectile(proj_rotation, 
			stats, 
			_muzzle.global_position, 
			knockback_direction, 
			false, 
			effects,
			null,
			damage_tracking_key
		)
