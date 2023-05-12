extends Node2D

@export var projectile_scene: PackedScene

class weapon:
	var speed := 400.0
	var terrain_damage := 0.10 # amount of damage this weapon does to terrain
	var character_damage := 15.0 # amount of damage this weapon does to players/enemies
	var lifetime := 100.0 # Time in seconds that fired projectiles will last before despawning
	var cooldown := 0.1 # Time in seconds before the next shot can be fired
	var max_ammo := 10 # How many times weapon can shoot before reload is required
	var reload_time := 1.5 # Time in seconds before 
	var is_reloading := false
	var current_ammo := 0
	var current_reload_time := 0.0
	var current_cooldown_time := 0.0

	func _init():
		return

	func shoot():
		if ((current_cooldown_time <= 0) and (current_ammo > 0)): # still has ammo & not on cooldown
			current_ammo -= 1
			current_cooldown_time = cooldown
		elif (current_ammo <= 0): # no more ammo
			current_reload_time = reload_time
			is_reloading = true
			
	func process_bullet_physics():
		return
		
	func on_character_collission():
		return
		
	func on_terrain_collission():
		return
	
	func reload(time_passed):
		current_reload_time -= time_passed
		if (current_reload_time <= 0):
			current_ammo = max_ammo
			is_reloading = false

	func on_despawn():
		return
