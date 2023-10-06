extends CharacterBody2D

@export var animations: SpriteFrames
@export var projectile_scene: PackedScene
@export var aim_reticle_scene: PackedScene
@export var weapons: Array[PackedScene] # The different types of projectile this character can shoot
@export var team = NO_TEAM # This character's team (e.g., teamed characters can't usually hurt each other)

signal die

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const JUMP_GRACE_PERIOD = 0.2 # Time in seconds to allow character to jump right after they slip off a ledge
const WALL_SLIDE_VELOCITY = 50.0 # Speed in which the player moves down when sliding on walls
const HIGH_GRAVITY_MODIFIER = 1.5 # How fast the player falls when they are not holding jump
const LOW_GRAVITY_MODIFIER = 0.4 # How much to multiply the gravity by when the player holds the jump key
const NO_TEAM = "NO_TEAM"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var selected_weapon # Parent node of currently selected weapon
var selected_weapon_index = 0

var wants_to_jump = false # Whether or not this character is trying to jump currently
var attack_cooldown = 0 # Time in seconds before the next attack can be done
var air_time = 0 # Time in seconds character is airborne
var aim_reticle # This character's aim reticle that they can attack towards
var health = 100.0 # How much punishment a character can take before they've had enough for the day
var max_health = health
var health_bar

func _ready():
	$AnimatedSprite2D.sprite_frames = animations
	# Add this character's reticle to the main scene
	add_aim_reticle()
	# Initialize health bar
	health_bar = get_node("HealthBar")
	health_bar.max_value = health
	health_bar.value = health
	add_weapons()
	
func add_aim_reticle():
	aim_reticle = aim_reticle_scene.instantiate()
	self.add_child.call_deferred(aim_reticle)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		air_time += delta
	else:
		air_time = 0

	# Handle Wall Sliding
	if is_touching_wall():
		# Wall Slide
		if velocity.y > 0:
			velocity.y = WALL_SLIDE_VELOCITY

	move_and_slide()

func is_touching_wall():
	if $WallClingRight.is_colliding():
		return true
	if $WallClingLeft.is_colliding():
		return true
	return false

func attack(emit_position = self.global_position):
	selected_weapon.shoot(emit_position)
	attack_cooldown = selected_weapon.cooldown
	return attack_cooldown

func take_damage(damage_amount):
	health -= damage_amount
	health_bar.value = health
	if (health <= 0):
		play_death_animation()
	
func play_death_animation():
	perish()
	
func perish():
	if (is_instance_valid(aim_reticle)):
		aim_reticle.queue_free()
	if (is_instance_valid(self)):
		print("Emitting death signal:", team)
		die.emit(team)
		queue_free()

func get_closest_in_group(groupName, living_things_only = true, check_same_team_only = false):
	var characters = get_tree().get_nodes_in_group(groupName)
	var closest = null
	var nearest_distance = INF
	for character in characters:
		if (living_things_only):
			# Check if living
			if (not character.is_in_group("Living")):
				continue
		# Check for teams
		if (check_same_team_only):
			# Only check for characters on our team
			if (character.team != team):
				continue
		elif (character.team == team):
			# Only check for characters on other teams
			continue
		var new_distance = position.distance_to(character.position)
		if (new_distance < nearest_distance):
			nearest_distance = new_distance
			closest = character
	return {"character": closest, "distance": nearest_distance}
	
func add_weapons():
	for weapon in weapons:
		add_weapon(weapon)
	
func add_weapon(weapon_scene):
	var new_weapon = weapon_scene.instantiate()
	new_weapon.aim_reticle = aim_reticle
	new_weapon.weapon_owner = get_instance_id()
	new_weapon.owner_collision_layer = 5 if get_collision_layer_value(5) else 6
	$WeaponHolder.add_child(new_weapon)
	if (selected_weapon):
		selected_weapon.set_enabled(false)
	selected_weapon = new_weapon
	selected_weapon.set_enabled(true)
	selected_weapon_index = $WeaponHolder.get_child_count() - 1
		
func next_weapon():
	selected_weapon.set_enabled(false)
	selected_weapon_index = (selected_weapon_index + 1) % $WeaponHolder.get_child_count()
	selected_weapon = $WeaponHolder.get_child(selected_weapon_index)
	selected_weapon.set_enabled(true)
	
func prev_weapon():
	selected_weapon.set_enabled(false)
	selected_weapon_index = (selected_weapon_index - 1) % $WeaponHolder.get_child_count()
	selected_weapon = $WeaponHolder.get_child(selected_weapon_index)
	selected_weapon.set_enabled(true)

func handle_jump():
	# Handle Jump.
	if is_on_floor() or air_time < JUMP_GRACE_PERIOD:
		velocity.y = JUMP_VELOCITY
		air_time = JUMP_GRACE_PERIOD

	# Handle Wall Jumps
	if is_touching_wall():
		# Wall Jump
		velocity.y = JUMP_VELOCITY

