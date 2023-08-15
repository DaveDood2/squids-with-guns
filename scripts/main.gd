extends Node2D

@export var navigation_region: NavigationRegion2D
@export var tilemap: TileMap
const EMPTY_TILE_COORDS = Vector2i(4, 5)
const TILE_SIZE = 16.0

signal increment_score
signal game_over

func _ready():
	pass
	#build_navigation_region()

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	# Reload the scene
	if Input.is_action_just_pressed("debug_reload"):
		print("[DEBUG] Reloaded scene!")
		get_tree().reload_current_scene()
	
	
func build_navigation_region():
	var maps = NavigationServer2D.get_maps()
	var regions_count = 0
	for map in maps:
		regions_count += 1
		print("Map: ", map, " RIDS:", NavigationServer2D.map_get_regions(map))
	print("Total regions: ", regions_count)


func _on_world_boundary_body_exited(body):
	if (body.is_in_group("Character")):
		#print("OOB:", body.name)
		body.perish()
		if (body.name == "Enemy"):
			increment_score.emit()
		if (body.name == "Player"):
			game_over.emit()
