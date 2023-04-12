extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var aim_reticle_scene: PackedScene


signal create_attack

const SPEED = 250.0
const JUMP_VELOCITY = -350.0
const JUMP_GRACE_PERIOD = 0.2 # Time in seconds to allow character to jump right after they slip off a ledge
const WALL_SLIDE_VELOCITY = 50.0 # Speed in which the player moves down when sliding on walls
const HIGH_GRAVITY_MODIFIER = 1.2 # How fast the player falls when they are not holding jump
const LOW_GRAVITY_MODIFIER = 0.5 # How much to multiply the gravity by when the player holds the jump key

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var attack_cooldown = 0 # Time in seconds before the next attack can be done
var air_time = 0 # Time in seconds character is airborne
var aim_reticle # This character's aim reticle that they can attack towards.

func _ready():
	# Add this character's reticle to the main scene
	aim_reticle = aim_reticle_scene.instantiate()
	get_tree().get_current_scene().add_child.call_deferred(aim_reticle)

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
	

	
	if Input.is_action_pressed("attack") and attack_cooldown <= 0:
		attack()
		attack_cooldown = 0.1
	else:
		attack_cooldown -= delta

func attack(emit_position = self.position):
	# Create projectile
	var projectile = projectile_scene.instantiate()
	projectile.position = emit_position
	
	# Point towards aiming reticle
	#projectile.look_at(aim_reticle.position)
	projectile.aiming_reticle = aim_reticle
	
	#add projectile
	get_tree().get_current_scene().add_child(projectile)
