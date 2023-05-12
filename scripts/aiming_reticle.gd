extends Node2D

@export var crosshair_offset = Vector2(0, 0)

var rotation_speed = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position() + crosshair_offset
	rotate(rotation_speed * delta)
