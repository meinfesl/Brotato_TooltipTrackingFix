extends "res://entities/structures/turret/turret.gd"

var mod_tooltiptracking_key = ""


func shoot()->void :
	WeaponService.mod_tooltiptracking.damage_tracking_key = mod_tooltiptracking_key
	.shoot()
	WeaponService.mod_tooltiptracking.damage_tracking_key = ""

