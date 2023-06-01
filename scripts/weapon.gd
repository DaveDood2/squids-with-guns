
extends Node2D

@export var projectile_scene: PackedScene

signal reload_started
signal reload_finished
var reload_timer

var speed := 400.0
var speed_variance := 10.0 # random amount the bullet's speed will vary
var terrain_damage := 0.10 # amount of damage this weapon does to terrain
var character_damage := 15.0 # amount of damage this weapon does to players/enemies
var lifetime := 20.0 # Time in seconds that fired projectiles will last before despawning
var lifetime_variance := 0.5 # random range the bullet's lifetime will vary
var cooldown := 0.02 # Time in seconds before the next shot can be fired
var max_ammo := 10 # How many times weapon can shoot before reload is required
var reload_time := 1.5 # Time in seconds before reload is finished
var is_reloading := false
var current_ammo
var aim_reticle
var spread := 0.1 # amount in degrees this weapon's shots can vary randomly
var bullet_amount := 1 # how many bullets are fired concurrently per shot
var weapon_owner = -1 # which character owns this weapon
var owner_collision_layer = -1 # Which collision layer the weapon's owner is on (5 for player, 6 for enemy)
var sway := 0.1 # How much the shooter's momentum affects the bullet's initial velocity

func _ready():
	current_ammo = max_ammo
	reload_timer = get_node("ReloadTimer")

func shoot(emit_position):
	if (current_ammo > 0): # still has ammo & not on cooldown
		print("Shot weapon")
		current_ammo -= 1
		for x in range(0, bullet_amount):
			spawn_bullet(emit_position)
	elif ((current_ammo <= 0) and (not is_reloading)): # no more ammo
		print("Reloading")
		reload_timer.start(reload_time)
		is_reloading = true
		
func spawn_bullet(emit_position):
	var projectile = projectile_scene.instantiate()
	projectile.position = emit_position
	projectile.look_at_position = aim_reticle.position
	projectile.spread = spread
	projectile.lifetime = lifetime + randf_range(-lifetime_variance/2.0, lifetime_variance/2.0)
	projectile.speed = speed + randf_range(-speed_variance/2.0, speed_variance/2.0)
	projectile.parent_velocity = get_parent().velocity
	projectile.parent_sway_modifier = sway
	projectile.bullet_owner = weapon_owner
	projectile.ignore_collision_layer = owner_collision_layer
	get_tree().get_current_scene().add_child(projectile)
	
func test(input):
	print("wowzers: ", input, self)

func _on_reload_timer_timeout():
	print("Finished reloading")
	current_ammo = max_ammo
	is_reloading = false
	reload_timer.stop()


func _on_reload_finished():
	pass # Replace with function body.
