extends "weapon.gd"


var bullet_amount = 5 # how many bullets are fired concurrently per shot
var spread = 15 # random spread of bullets in degrees

# Called when the node enters the scene tree for the first time.
func _ready():
	character_damage = 15.0 # amount of damage this weapon does to players/enemies
	lifetime = 1.0 # Time in seconds that fired projectiles will last before despawning
	cooldown = 0.3 # Time in seconds before the next shot can be fired
	max_ammo = 2 # How many times weapon can shoot before reload is required
	reload_time = 1.0 # Time in seconds before reload finished
	pass # Replace with function body.

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
	projectile.look_at(aim_reticle.position)
	get_tree().get_current_scene().add_child(projectile)
