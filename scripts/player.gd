extends "character.gd"

func _physics_process(delta):
	super._physics_process(delta)
	
	# Lessen the gravity if jump is held
	if Input.is_action_pressed("jump"):
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * LOW_GRAVITY_MODIFIER
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * HIGH_GRAVITY_MODIFIER

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		handle_jump()

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
