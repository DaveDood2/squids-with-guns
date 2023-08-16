extends Camera2D

@export var zoom_speed = 10
@export var initial_zoom := 1.2
@export var offset_scale := 0.2
var max_zoom = 4
var min_zoom = 0.3
var screen_center

func _ready():
	zoom = Vector2(initial_zoom,initial_zoom)
	screen_center = get_viewport_rect().size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle zooming in/out
	if Input.is_action_just_released("zoom_in"):
		zoom_tween(zoom + (Vector2(zoom_speed,zoom_speed) * delta))
	if Input.is_action_just_released("zoom_out"):
		zoom_tween(zoom - (Vector2(zoom_speed,zoom_speed) * delta))
		
	# Handle moving camera towards the mouse pointer
	offset = (get_viewport().get_mouse_position() - screen_center) * offset_scale

		
func zoom_tween(zoom_amount):
	var tween = get_tree().create_tween()
	zoom_amount = zoom_amount.clamp(Vector2(min_zoom,min_zoom), Vector2(max_zoom, max_zoom))
	tween.tween_property(self, "zoom", zoom_amount, 0.75)
	
