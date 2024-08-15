extends "enemy.gd"

var initial_sprite_modulation
var initial_sprite_scaling

func _ready():
	super._ready()
	# Remember the initial sprite scaling/modulcaiton in order to reverse the death animation
	initial_sprite_modulation = $AnimatedSprite2D.modulate
	initial_sprite_scaling = $AnimatedSprite2D.scale

func perish():
	health = max_health
	var nearest_respawner = get_closest_in_group("Respawn Totem", false, true)
	position = nearest_respawner.character.position
	$AnimatedSprite2D.modulate = initial_sprite_modulation
	$AnimatedSprite2D.scale = initial_sprite_scaling
	add_to_group("Living")
