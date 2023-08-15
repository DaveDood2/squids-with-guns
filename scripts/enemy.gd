extends "character.gd"

var state = "parachuting"
var search_radius = 400.0
var navigator
var parachute_fall_modifier := 0.05

func _ready():
	super._ready()
	aim_reticle.follow_mouse = false
	aim_reticle.follow_players = true
	aim_reticle.visible = false
	aim_reticle.position = position
	navigator = get_node("NavigationAgent2D")

func _physics_process(delta):
	if (not is_in_group("Living")):
		super._physics_process(delta)
	match(state):
		"parachuting":
			$AnimatedSprite2D.play("parachuting")
			if not is_on_floor():
				velocity.y += gravity * delta * parachute_fall_modifier
				move_and_slide()
			else:
				state = "idle"

		"idle":
			$AnimatedSprite2D.play("idle")
			super._physics_process(delta)
			var nearest_target = get_closest_in_group("Character", true, false)
			if (nearest_target.distance <= search_radius):
				navigator.target_position = nearest_target.character.position
				state = "attacking"
				aim_reticle.assign_target(nearest_target.character)

		"attacking":
			$AnimatedSprite2D.play("hostile")
			super._physics_process(delta)
			if attack_cooldown <= 0:
				attack()
				var nearest_target = get_closest_in_group("Character", true, false)
				if (is_instance_valid(nearest_target.character) and nearest_target.character.is_in_group("Living")):
					aim_reticle.assign_target(nearest_target.character)
					chase(nearest_target.character.position)
				else:
					state = "idle"
			else:
				attack_cooldown -= delta
			
		_:
			printerr("Invalid state:", state)

func take_damage(amount):
	super.take_damage(amount)
	if (state == "idle"):
		state = "attacking"
	
func play_death_animation():
	remove_from_group("Living")
	$SFX/death.play()
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 1)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(), 1)
	tween.tween_callback(perish)
		
func perish():
	super.perish()
	
func chase(target):
	# Based on code from: https://www.youtube.com/watch?v=lOS2SptNiBM
	if (!navigator.is_navigation_finished()):
		var next_location = navigator.get_next_path_position()
		var direction = global_position.direction_to(next_location)
		if direction.y < 0:
			handle_jump()
		if direction:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
	else:
		navigator.target_position = target
		




