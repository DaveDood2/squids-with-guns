extends "character.gd"

@export var player_num = 1

var _pNum = "_p0" # The player's number, if this character is a player.

func _ready():
	_pNum = "_p{player_num}".format({"player_num":player_num})
	super._ready()
	health = 1000
	health_bar.max_value = health
	health_bar.value = health

func add_aim_reticle():
	aim_reticle = aim_reticle_scene.instantiate()
	aim_reticle.set_pNum(_pNum)
	self.add_child.call_deferred(aim_reticle)

func _physics_process(delta):
	super._physics_process(delta)
	# Lessen the gravity if jump is held
	if Input.is_action_pressed("jump"+_pNum):
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * LOW_GRAVITY_MODIFIER
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * HIGH_GRAVITY_MODIFIER

	# Handle Jump.
	if Input.is_action_just_pressed("jump"+_pNum):
		handle_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left"+_pNum, "move_right"+_pNum)
	if direction:
		$AnimatedSprite2D.play("default")
		velocity.x = direction * SPEED
	else:
		$AnimatedSprite2D.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# attacking
	if (Input.is_action_pressed("attack"+_pNum)) and (attack_cooldown <= 0):
		attack_cooldown = attack()
	else:
		attack_cooldown -= delta
		
	# swapping weapons
	if (Input.is_action_just_pressed("next_weapon"+_pNum)):
		next_weapon()
	if (Input.is_action_just_pressed("prev_weapon"+_pNum)):
		prev_weapon()
	
