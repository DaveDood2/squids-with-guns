# Projectile code loosely based on https://www.youtube.com/watch?v=jMk8Zm-F3jw

extends CharacterBody2D

@export var character_scene: PackedScene

var speed := 400.0
var terrain_damage := 0.25 # amount of damage this bullet does to terrain
var character_damage := 25.0 # amount of damage this bullet does to players/enemies
var lifetime := 100.0 # Time in seconds that this projectile will last before despawning
var aiming_reticle
var team = "" # The group that this projectile originated from (and will not hurt)
var bullet_owner = -1 # The instance ID of the character that shot this bullet
var friendly_fire := false # Whether or not this bullet can hurt its owner/teammates
var look_at_position
var spread = 0 # amount in degrees this bullet randomly turn before traveling
var parent_velocity = Vector2() # parent's velocity gets added to bullet (e.g., running and shooting forwards yields faster bullet) 
var ignore_collision_layer = -1 # Which collision layer to ignore (5 for player 6 for enemy)
var parent_sway_modifier := 0.25 # How much the shooter's momentum affects this bullet
const EMPTY_TILE_COORDS = Vector2i(4, 5)
var ready_for_queue_free := false

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(look_at_position)
	rotate(randf_range(-spread/2.0, spread/2.0))
	set_collision_mask_value(ignore_collision_layer, false)

func _physics_process(delta):
	if (ready_for_queue_free):
		return
	if (lifetime < 0):
		perish()
	lifetime -= delta
	#look_at(get_global_mouse_position())
	var veloc = (Vector2.RIGHT.rotated(rotation) * speed * delta) + (parent_velocity * delta * parent_sway_modifier)
	var collision = move_and_collide(veloc)
	if collision:
		var collider = collision.get_collider()
		
		#Bullet hit a character
		if collider.is_in_group("Character"):
			#Check to make sure this isn't the bullet's owner nor a teammate
			if ((friendly_fire == false)
					and (collider.get_instance_id() != bullet_owner)
					and (collider.team != team)
			):
				collider.take_damage(character_damage)
				perish()
			
		#Bullet hit the terrain
		elif collider.name == "TileMap": #Destroying tilemap w/ bullets: https://www.reddit.com/r/godot/comments/i0pzf6/how_to_implement_destructible_tiles_in_godot/
			$SFX/HitTileSfx.play()
			var cell = collider.local_to_map(collision.get_position() - collision.get_normal())
			var tile_data = collider.get_cell_tile_data(0, cell)
			if (!tile_data):
				# Necessary to avoid a bug when a bullet hits stairs at a weird angle.
				# The bullet will collide but not be close enough to register being on the tile.
				#print("Skipped")
				perish()
			else: # Tile data exists
				# Check if tile is unbreakable
				if (!tile_data.get_custom_data("isBreakable")):
					perish()
				else: # Tile is breakable and should be damaged.
					var new_tile_health = tile_data.get_custom_data("Durability") - terrain_damage
					#print("Tile health: %s" % new_tile_health)
					if (new_tile_health <= 0):
						collider.set_cell(0, cell, 0, EMPTY_TILE_COORDS)
					else:
						#collider.set_cell(0, cell, 0, EMPTY_TILE_COORDS)
						tile_data.set_custom_data("Durability", new_tile_health)
					#print("Collision:" + tile_id)
					perish()
	
func perish():
	ready_for_queue_free = true
	hide()
	if ($SFX/HitTileSfx.playing == false):
		queue_free()

func _on_hit_tile_sfx_finished():
	if (ready_for_queue_free):
		queue_free()
