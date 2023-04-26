extends Node2D

@export var crosshair_offset = Vector2(0, 0)

var rotation_speed = 3
var follow_mouse = true
var follow_players = false
var move_towards_players_speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (follow_mouse):
		position = get_global_mouse_position() + crosshair_offset
	elif (follow_players):
		var players = get_tree().get_nodes_in_group("Player")
		if (players):
			#Todo: look at closest player
			position = position.move_toward(players[0].position, move_towards_players_speed * delta)
			
	rotate(rotation_speed * delta)
