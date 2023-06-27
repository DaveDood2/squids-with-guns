extends Node2D

@export var navigation_region: NavigationRegion2D
@export var tilemap: TileMap
const EMPTY_TILE_COORDS = Vector2i(4, 5)
const TILE_SIZE = 16.0

func _ready():
	build_navigation_region()

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	# Reload the scene
	if Input.is_action_just_pressed("debug_reload"):
		print("[DEBUG] Reloaded scene!")
		get_tree().reload_current_scene()
	
		
func build_navigation_region():
	var navigation_outline = PackedVector2Array()
	var navigation_polygon = NavigationPolygon.new()
	for i in tilemap.get_used_cells(0):
		if (tilemap.get_cell_atlas_coords(0, i) != EMPTY_TILE_COORDS):
			# There is air here, add it to the navigation polygon region
			var new_square = PackedVector2Array()
			var square_center = to_global(tilemap.map_to_local(i))
			new_square.append(square_center + Vector2(-TILE_SIZE/2, -TILE_SIZE/2))
			new_square.append(square_center + Vector2(-TILE_SIZE/2, TILE_SIZE/2))
			new_square.append(square_center + Vector2(TILE_SIZE/2, TILE_SIZE/2))
			new_square.append(square_center + Vector2(TILE_SIZE/2, -TILE_SIZE/2))
			#navigation_outline = Geometry2D.merge_polygons(navigation_outline, new_square)
			navigation_polygon.add_outline(new_square)
	navigation_polygon.make_polygons_from_outlines()
	navigation_region.navigation_polygon = navigation_polygon
	print("Polygons:", navigation_polygon.get_polygon_count())
	return
