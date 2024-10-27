extends Node

const MOD_NAME = "meinfesl-TooltipTrackingFix"

const MOD_PATH = "res://mods-unpacked/meinfesl-TooltipTrackingFix/"

var damage_tracking_key:String = ""


func _init(_modLoader = ModLoader):
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/entities/structures/turret/turret.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/entities/structures/structure.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/singletons/run_data.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/singletons/weapon_service.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/main.gd")

	var structure_tracker = load(MOD_PATH + "structure_tracker.gd").new()
	structure_tracker.name = "StructureTracker"
	add_child(structure_tracker)
	
	ModLoaderLog.info("Initialized", MOD_NAME)

func _ready():
	var res = load("res://items/all/pocket_factory/pocket_factory_data.tres")
	res.tracking_text = "DAMAGE_DEALT"
	
	ModLoaderLog.info("Ready", MOD_NAME)

