extends "character.gd"

var state = "idle"
var search_radius = 400.0
var navigator
@export var avoidance_radius = 10.0

func _ready():
	super._ready()
	team = "Enemy"
	aim_reticle.follow_mouse = false
	aim_reticle.follow_players = true
	navigator = get_node("NavigationAgent2D")
	navigator.set_radius(avoidance_radius)
	navigator.set_avoidance_enabled(true)

func _physics_process(delta):
	super._physics_process(delta)

	if (state == "idle"):
		var nearest_player = get_closest_in_group("Player")
		if (nearest_player.distance <= search_radius):
			state = "attacking"
			aim_reticle.assign_target(nearest_player.character)

	if (state == "attacking"):
		if attack_cooldown <= 0:
			attack_cooldown = 0 #attack()
			var target = get_closest_in_group("Player")
			if (is_instance_valid(target.character)):
				aim_reticle.assign_target(target.character)
				chase(target.character.position)
			else:
				state = "idle"
		else:
			attack_cooldown -= delta

func take_damage(amount):
	super.take_damage(amount)
	state = "attacking"
	
func chase(target):
	# Based on code from: https://www.youtube.com/watch?v=lOS2SptNiBM
	navigator.target_position = target
	if (navigator.is_target_reachable()):
		var next_location = navigator.get_next_path_position()
		var direction = global_position.direction_to(next_location)
		if direction.y < 0:
			handle_jump()
		if direction:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()


