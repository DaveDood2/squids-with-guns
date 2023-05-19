extends "character.gd"

var state = "idle"
var search_radius = 50.0

func _ready():
	super._ready()
	team = "Enemy"
	aim_reticle.follow_mouse = false
	aim_reticle.follow_players = true

func _physics_process(delta):
	super._physics_process(delta)

	if (state == "idle"):
		var nearest_player = get_closest_in_group("Player")
		if (nearest_player.distance <= search_radius):
			state = "attacking"
			aim_reticle.assign_target(nearest_player.character)

	if (state == "attacking"):
		if attack_cooldown <= 0:
			#attack()
			attack_cooldown = 0.1
			var target = get_closest_in_group("Player").character
			if (!is_instance_valid(target)):
				state = "idle"
			else:
				aim_reticle.assign_target(target)
		else:
			attack_cooldown -= delta

func take_damage(amount):
	super.take_damage(amount)
	state = "attacking"
