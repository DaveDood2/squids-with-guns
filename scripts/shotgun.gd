extends "weapon.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	character_damage = 15.0 # amount of damage this weapon does to players/enemies
	lifetime = 0.7 # Time in seconds that fired projectiles will last before despawning
	cooldown = 0.3 # Time in seconds before the next shot can be fired
	max_ammo = 2 # How many times weapon can shoot before reload is required
	reload_time = 1.0 # Time in seconds before reload finished
	spread = 0.7 # random spread of bullets in degrees
	bullet_amount = 5 # how many bullets are fired concurrently per shot
	speed = 300
	super._ready()
	
