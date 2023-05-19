extends CharacterBody2D

@export var projectile_scene: PackedScene
@export var aim_reticle_scene: PackedScene
@export var weapon_scene: PackedScene


signal create_attack

const SPEED = 250.0
const JUMP_VELOCITY = -350.0
const JUMP_GRACE_PERIOD = 0.2 # Time in seconds to allow character to jump right after they slip off a ledge
const WALL_SLIDE_VELOCITY = 50.0 # Speed in which the player moves down when sliding on walls
const HIGH_GRAVITY_MODIFIER = 1.2 # How fast the player falls when they are not holding jump
const LOW_GRAVITY_MODIFIER = 0.5 # How much to multiply the gravity by when the player holds the jump key
const NO_TEAM = "NO_TEAM"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var weapons = [] # The different types of projectile this character can shoot
var selected_weapon # Index of currently selected weapon


var attack_cooldown = 0 # Time in seconds before the next attack can be done
var air_time = 0 # Time in seconds character is airborne
var aim_reticle # This character's aim reticle that they can attack towards
var health = 100.0 # How much punishment a character can take before they've had enough for the day
var health_bar

var team = NO_TEAM # This character's team (e.g., teamed characters can't usually hurt each other)

func _ready():
	# Add this character's reticle to the main scene
	aim_reticle = aim_reticle_scene.instantiate()
	get_tree().get_current_scene().add_child.call_deferred(aim_reticle)
	#Initialize health bar
	health_bar = get_node("HealthBar")
	health_bar.max_value = health
	health_bar.value = health
	add_weapon()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		air_time += delta
	else:
		air_time = 0

	# Handle Wall Sliding/Wall Jumps
	if is_on_wall_only():
		# Wall Slide
		if velocity.y > 0:
			velocity.y = WALL_SLIDE_VELOCITY

	move_and_slide()



func attack(emit_position = self.position):
	selected_weapon.shoot(emit_position)
	var attack_cooldown = selected_weapon.cooldown
	return attack_cooldown

func take_damage(damage_amount):
	health -= damage_amount
	health_bar.value = health
	if (health <= 0):
		perish()
	
	
func perish():
	aim_reticle.queue_free()
	queue_free()


func get_closest_in_group(groupName):
	var characters = get_tree().get_nodes_in_group(groupName)
	var closest = null
	var nearest_distance = INF
	for character in characters:
		var new_distance = position.distance_to(character.position)
		if (new_distance < nearest_distance):
			nearest_distance = new_distance
			closest = character
	return {"character": closest, "distance": nearest_distance}
	
	
func add_weapon():
	var new_weapon = weapon_scene.instantiate()
	new_weapon.aim_reticle = aim_reticle
	add_child(new_weapon)
	selected_weapon = new_weapon
	return
