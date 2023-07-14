extends "res://singletons/run_data.gd"

func init_tracked_effects() -> Dictionary:
	var base = .init_tracked_effects()
	var ext = {
		"item_landmines":0,
		"item_turret":0,
		"item_turret_flame":0,
		"item_turret_laser":0,
		"item_turret_rocket":0,
		"item_turret_healing":0,
		"item_tyler":0,
		"item_pocket_factory":0,
		"character_bull":0,
	}
	base.merge(ext)
	return base

func reset(restart:bool = false)->void :
	.reset(restart)
	
	var structure_tracker = get_tree().get_root().get_node("ModLoader/meinfesl-TooltipTrackingFix/StructureTracker")
	structure_tracker.reset_spawn_counter()
