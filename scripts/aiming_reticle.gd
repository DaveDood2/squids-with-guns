extends Node2D

@export var crosshair_offset = Vector2(0, 0)

var rotation_speed = 3
var follow_player_input = true
var follow_player_input_mouse = true
var follow_players = false
var move_towards_players_speed = 400.0
var target = null
var joystick_radius := 40.0
var joystick_deadzone := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var controller_vector = Input.get_vector("reticle_left", "reticle_right", "reticle_up", "reticle_down")
	# Detect if the player is currently using the mouse or controller to aim
	if (controller_vector):
		follow_player_input_mouse = false
	elif (Input.get_last_mouse_velocity()):
		follow_player_input_mouse = true
		
	# Handle player moving aiming reticle
	if (follow_player_input):
		if (follow_player_input_mouse):
			global_position = get_global_mouse_position() + crosshair_offset
		else:
			if (controller_vector.length() > joystick_deadzone):
				position = controller_vector * joystick_radius
			
	# Handle moving the aiming reticle as an NPC
	elif (follow_players and is_instance_valid(target)):
		position = position.move_toward(target.position, move_towards_players_speed * delta)
			
	rotate(rotation_speed * delta)

func assign_target(character):
	target = character
