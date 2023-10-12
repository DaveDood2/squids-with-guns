extends "weapon.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	character_damage = 15.0 # amount of damage this weapon does to players/enemies
	lifetime = 0.9 # Time in seconds that fired projectiles will last before despawning
	lifetime_variance = 0.3
	cooldown = 0.3 # Time in seconds before the next shot can be fired
	max_ammo = 2 # How many times weapon can shoot before reload is required
	reload_time = 1.0 # Time in seconds before reload finished
	spread = 0.5 # random spread of bullets in degrees
	bullet_amount = 5 # how many bullets are fired concurrently per shot
	speed = 400
	speed_variance = 150
	sway = 0.1
	super._ready()
	
func draw_gun():
	$GunSprite.look_at(aim_reticle.global_position)
	var rot = rad_to_deg((aim_reticle.position - $GunSprite.position).angle())
	if (rot >= -90 and rot <= 90):
		$GunSprite.flip_v = 0
		$GunSprite/BulletSpawnPoint.position.y = 0
	else:
		$GunSprite.flip_v = 1
		$GunSprite/BulletSpawnPoint.position.y = 6
