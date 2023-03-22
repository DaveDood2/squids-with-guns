extends Camera2D

@export var zoom_speed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("zoom_in"):
		zoom += Vector2(zoom_speed,zoom_speed) * delta
		print("Zoom in!")
	if Input.is_action_just_released("zoom_out"):
		zoom -= Vector2(zoom_speed,zoom_speed) * delta
