extends "res://main.gd"

func clean_up_room(is_last_wave:bool = false, is_run_lost:bool = false, is_run_won:bool = false)->void :
	.clean_up_room(is_last_wave, is_run_lost, is_run_won)
	
	var tracker = get_tree().get_root().get_node("ModLoader/meinfesl-TooltipTrackingFix/StructureTracker")
	tracker.reset_spawn_counter()

