extends "res://entities/structures/structure.gd"

func _ready():
	var tracker = get_tree().get_root().get_node("ModLoader/meinfesl-TooltipTrackingFix/StructureTracker")
	tracker.structure_spawned(self)
