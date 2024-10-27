extends "res://singletons/weapon_service.gd"

onready var mod_tooltiptracking = get_tree().get_root().get_node("ModLoader/meinfesl-TooltipTrackingFix")


func spawn_projectile(
		pos: Vector2, 
		weapon_stats: RangedWeaponStats, 
		direction: float, 
		from: Node, 
		args: WeaponServiceSpawnProjectileArgs
	)->Node:
	
	if args.damage_tracking_key == "" and mod_tooltiptracking.damage_tracking_key != "":
		args.damage_tracking_key = mod_tooltiptracking.damage_tracking_key
	if args.damage_tracking_key == "item_turret" and mod_tooltiptracking.damage_tracking_key == "item_pocket_factory":
		args.damage_tracking_key = "item_pocket_factory"
	return .spawn_projectile(pos, weapon_stats, direction, from, args)

# Obsolete?
func explode(effect: Effect, args: WeaponServiceExplodeArgs)->Node:
	if args.damage_tracking_key == "" and mod_tooltiptracking.damage_tracking_key != "":
		args.damage_tracking_key = mod_tooltiptracking.damage_tracking_key
	return .explode(effect, args)
