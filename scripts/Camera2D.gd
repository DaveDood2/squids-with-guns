extends Camera2D

@export var zoom_speed = 10
@export var initial_zoom := 1.2
var max_zoom = 4
var min_zoom = 0.3

func _ready():
	zoom = Vector2(initial_zoom,initial_zoom)
	print("size:", get_viewport().get_mouse_position())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("zoom_in"):
		zoom += Vector2(zoom_speed,zoom_speed) * delta
		zoom = zoom.clamp(Vector2(min_zoom,min_zoom), Vector2(max_zoom, max_zoom))
	if Input.is_action_just_released("zoom_out"):
		zoom -= Vector2(zoom_speed,zoom_speed) * delta
		zoom = zoom.clamp(Vector2(min_zoom,min_zoom), Vector2(max_zoom, max_zoom))
