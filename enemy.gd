extends "character.gd"

func _ready():
	super._ready()
	team = "Enemy"
	aim_reticle.follow_mouse = false
	aim_reticle.follow_players = true

func _physics_process(delta):
	super._physics_process(delta)
	
	if attack_cooldown <= 0:
		attack()
		attack_cooldown = 0.1
	else:
		attack_cooldown -= delta
