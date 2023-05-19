extends "character.gd"

func _physics_process(delta):
	# Lessen the gravity if jump is held
	if Input.is_action_pressed("jump"):
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * LOW_GRAVITY_MODIFIER
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * HIGH_GRAVITY_MODIFIER
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		air_time += delta
	else:
		air_time = 0

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or air_time < JUMP_GRACE_PERIOD:
			velocity.y = JUMP_VELOCITY
			air_time = JUMP_GRACE_PERIOD

	# Handle Wall Sliding/Wall Jumps
	if is_on_wall_only():
		# Wall Jump
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		# Wall Slide
		elif velocity.y > 0:
			velocity.y = WALL_SLIDE_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# attacking
	if (Input.is_action_pressed("attack")) and (attack_cooldown <= 0):
		attack_cooldown = attack()
	else:
		attack_cooldown -= delta
