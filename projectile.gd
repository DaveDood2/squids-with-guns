# Projectile code loosely based on https://www.youtube.com/watch?v=jMk8Zm-F3jw

extends CharacterBody2D

var direction := Vector2.RIGHT.rotated(rotation)
var speed := 400.0
var aiming_reticle

# Called when the node enters the scene tree for the first time.
func _ready():
	#direction = direction.normalized()
	look_at(aiming_reticle.position)
	pass # Replace with function body.

func _physics_process(delta):
	#look_at(get_global_mouse_position())
	var velocity = Vector2.RIGHT.rotated(rotation) * speed * delta
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()
	
	
#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()
