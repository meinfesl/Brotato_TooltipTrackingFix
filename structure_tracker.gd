class_name StructureTracker
extends Node

var spawn_counter = 0

func reset_spawn_counter():
	spawn_counter = 0

# Just simply count on structure creation.
# RunData.effects["structures"] spawn all together at the start of the wave.
# Everything that spawns after is either a turret from pocket factory or a non-initial landmine.
func structure_spawned(structure):
	spawn_counter += 1
	
	var path = structure.get_path()
	var structure_name = path.get_name(path.get_name_count() - 1)
	
	if structure_name.begins_with("@"):
		structure_name = structure_name.substr(1)
			
	if structure_name.begins_with("Turret"):
		if spawn_counter > RunData.effects["structures"].size():
			structure.damage_tracking_key = "item_pocket_factory"
		else:
			structure.damage_tracking_key = "item_turret"
	elif structure_name.begins_with("FlameTurret"):
		structure.damage_tracking_key = "item_turret_flame"
	elif structure_name.begins_with("LaserTurret"):
		structure.damage_tracking_key = "item_turret_laser"
	elif structure_name.begins_with("RocketTurret"):
		structure.damage_tracking_key = "item_turret_rocket"
	elif structure_name.begins_with("Tyler"):
		structure.damage_tracking_key = "item_tyler"
	elif structure_name.begins_with("HealingTurret"):
		structure.damage_tracking_key = "item_turret_healing"
