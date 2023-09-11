extends Node2D

@export var crosshair_offset = Vector2(0, 0)

var rotation_speed = 3
var follow_player_input = true
var follow_player_input_mouse = true
var follow_players = false
var move_towards_players_speed = 400.0
var target = null
var joystick_radius := 80.0
var joystick_deadzone := 0.5
var _pNum = "_p0"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_pNum(player_num):
	_pNum = player_num
	# Allow mouse movement if player 1, disallow for controller players.
	if (_pNum == "_p1"):
		follow_player_input_mouse = true
	else:
		follow_player_input_mouse = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var controller_vector = Input.get_vector("reticle_left"+_pNum, "reticle_right"+_pNum, "reticle_up"+_pNum, "reticle_down"+_pNum)
		
	# Handle player moving aiming reticle
	if (follow_player_input):
		if (follow_player_input_mouse):
			global_position = get_global_mouse_position() + crosshair_offset
		else:
			if (controller_vector.length() > joystick_deadzone):
				position = controller_vector * joystick_radius
			
	# Handle moving the aiming reticle as an NPC
	elif (follow_players and is_instance_valid(target)):
		global_position = global_position.move_toward(target.position, move_towards_players_speed * delta)
			
	rotate(rotation_speed * delta)

func assign_target(character):
	target = character
