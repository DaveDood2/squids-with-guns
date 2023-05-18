
extends Node2D

@export var projectile_scene: PackedScene

var reload_timer

var speed := 400.0
var terrain_damage := 0.10 # amount of damage this weapon does to terrain
var character_damage := 15.0 # amount of damage this weapon does to players/enemies
var lifetime := 100.0 # Time in seconds that fired projectiles will last before despawning
var cooldown := 0.02 # Time in seconds before the next shot can be fired
var max_ammo := 10 # How many times weapon can shoot before reload is required
var reload_time := 1.5 # Time in seconds before reload is finished
var is_reloading := false
var current_ammo := max_ammo
var aim_reticle
	
func _ready():
	print(get_children())
	reload_timer = get_node("ReloadTimer")

func shoot(emit_position):
	if (current_ammo > 0): # still has ammo & not on cooldown
		print("Shot weapon")
		current_ammo -= 1
		spawn_bullet(emit_position)
	elif ((current_ammo <= 0) and (not is_reloading)): # no more ammo
		print("Reloading")
		reload_timer.start(reload_time)
		is_reloading = true
		
func spawn_bullet(emit_position):
	var projectile = projectile_scene.instantiate()
	projectile.position = emit_position
	projectile.ready_bullet = Callable(projectile, "test")
	projectile.look_at_position = aim_reticle.position
	get_tree().get_current_scene().add_child(projectile)
	
func bullet_ready(look_at_position):
	look_at(look_at_position)
	return
	
func test(input):
	print("wowzers: ", input, self)

func process_bullet_physics():
	return
	
func on_character_collission():
	return
	
func on_terrain_collission():
	return

func on_despawn():
	return


func _on_reload_timer_timeout():
	print("Finished reloading")
	current_ammo = max_ammo
	is_reloading = false
	reload_timer.stop()
