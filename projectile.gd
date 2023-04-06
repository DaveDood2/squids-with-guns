# Projectile code loosely based on https://www.youtube.com/watch?v=jMk8Zm-F3jw

extends CharacterBody2D

var speed := 400.0
var terrain_damage := 0.25 # amount of damage this bullet does to terrain
var character_damage := 25.0 # amount of damage this bullet does to players/enemies
var lifetime := 100.0 # Time in seconds that this projectile will last before despawning
var aiming_reticle
var tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(aiming_reticle.position)
	tilemap = get_parent().get_node("TileMap")

func _physics_process(delta):
	if (lifetime < 0):
		queue_free()
	lifetime -= delta
	#look_at(get_global_mouse_position())
	var velocity = Vector2.RIGHT.rotated(rotation) * speed * delta
	var collision = move_and_collide(velocity)
	if collision:
		if collision.get_collider().name == "TileMap": #Destroying tilemap w/ bullets: https://www.reddit.com/r/godot/comments/i0pzf6/how_to_implement_destructible_tiles_in_godot/
			var cell = tilemap.local_to_map(collision.get_position() - collision.get_normal())
			var tile_data = tilemap.get_cell_tile_data(0, cell)
			var new_tile_health = tile_data.get_custom_data("Durability") - terrain_damage
			print("Tile health: %s" % new_tile_health)
			if (new_tile_health <= 0):
				tilemap.set_cell(0, cell, -1)
			else:
				tile_data.set_custom_data("Durability", new_tile_health)
			#print("Collision:" + tile_id)
		queue_free()
	
	
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()
