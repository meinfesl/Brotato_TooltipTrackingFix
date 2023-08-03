extends Node

const MOD_NAME = "meinfesl-TooltipTrackingFix"

const MOD_PATH = "res://mods-unpacked/meinfesl-TooltipTrackingFix/"

var damage_tracking_key:String = ""
var flame_turret_burning = false

func _init(modLoader = ModLoader):
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/entities/structures/turret/turret.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/entities/structures/structure.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/entities/units/player/player.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/entities/units/unit/unit.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/singletons/run_data.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/singletons/weapon_service.gd")
	ModLoaderMod.install_script_extension(MOD_PATH + "extensions/main.gd")
	
	var structure_tracker = load(MOD_PATH + "structure_tracker.gd").new()
	structure_tracker.name = "StructureTracker"
	add_child(structure_tracker)
	
	ModLoaderLog.info("Initialized", MOD_NAME)

func _ready():
	var res = load("res://items/all/turret/turret_data.tres")
	res.tracking_text = "DAMAGE_DEALT";
	
	res = load("res://items/all/turret_flame/turret_flame_data.tres")
	res.tracking_text = "DAMAGE_DEALT";
	
	res = load("res://items/all/turret_laser/turret_laser_data.tres")
	res.tracking_text = "DAMAGE_DEALT";
	
	res = load("res://items/all/turret_rocket/turret_rocket_data.tres")
	res.tracking_text = "DAMAGE_DEALT";
	
	res = load("res://items/all/turret_healing/turret_healing_data.tres")
	res.tracking_text = "HEALTH_RECOVERED";
	
	res = load("res://items/all/landmines/landmines_data.tres")
	res.tracking_text = "DAMAGE_DEALT"
	
	res = load("res://items/all/landmines/landmine_exploding_effect.tres")
	res.tracking_text = "item_landmines"
	
	res = load("res://items/all/tyler/tyler_data.tres")
	res.tracking_text = "DAMAGE_DEALT"
	
	res = load("res://items/characters/bull/bull_data.tres")
	res.tracking_text = "DAMAGE_DEALT"
	
	res = load("res://items/characters/bull/bull_effect_4.tres")
	res.tracking_text = "character_bull"
	
	res = load("res://items/characters/lucky/lucky_data.tres")
	res.tracking_text = "DAMAGE_DEALT"
	
	res = load("res://items/all/pocket_factory/pocket_factory_data.tres")
	res.tracking_text = "DAMAGE_DEALT"
	
	ModLoaderLog.info("Ready", MOD_NAME)

