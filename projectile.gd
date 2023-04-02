# Projectile code loosely based on https://www.youtube.com/watch?v=jMk8Zm-F3jw

extends CharacterBody2D

var direction := Vector2.RIGHT.rotated(rotation)
var speed := 400.0
var aiming_reticle
var tilemap
var cell
var tile_id

# Called when the node enters the scene tree for the first time.
func _ready():
	#direction = direction.normalized()
	look_at(aiming_reticle.position)
	tilemap = get_parent().get_node("TileMap")

func _physics_process(delta):
	#look_at(get_global_mouse_position())
	var velocity = Vector2.RIGHT.rotated(rotation) * speed * delta
	var collision = move_and_collide(velocity)
	if collision:
		if collision.get_collider().name == "TileMap": #Destroying tilemap w/ bullets: https://www.reddit.com/r/godot/comments/i0pzf6/how_to_implement_destructible_tiles_in_godot/
			cell = tilemap.local_to_map(collision.get_position() - collision.get_normal())
			tile_id = tilemap.get_cell_source_id(0, cell)
			tilemap.set_cell(0, cell, -1)
			#print("Collision:" + tile_id)
		queue_free()
	
	
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()
