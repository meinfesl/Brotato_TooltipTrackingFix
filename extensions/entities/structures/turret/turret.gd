extends "res://entities/structures/turret/turret.gd"

var damage_tracking_key = ""

# Completely overrides base method
func shoot()->void :
	WeaponService.mod_tooltiptracking.damage_tracking_key = damage_tracking_key
	.shoot()
	WeaponService.mod_tooltiptracking.damage_tracking_key = ""

