extends Node

@export var navigation_region: NavigationRegion2D
@export var tilemap: TileMap

func _ready():
	build_navigation_region()

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	# Reload the scene
	if Input.is_action_just_pressed("debug_reload"):
		print("[DEBUG] Reloaded scene!")
		get_tree().reload_current_scene()
	
		
func build_navigation_region():
	return
