extends Node2D

@export var level_scene : PackedScene

signal increment_score
signal game_over

var playerCount = 2

func _ready():
	# Set player 2's world to be the same as player 1's so they see the same thing.
	# TODO: clean up code to account for handling viewports with 1, 3, and 4 players.
	#$VBoxContainer/SubViewportContainer2/SubViewport.world_2d = $VBoxContainer/SubViewportContainer/SubViewport.world_2d
	var levelNode = level_scene.instantiate()
	var world_2d
	for player in range(1, playerCount + 1):
		var newPlayerView = SubViewportContainer.new()
		newPlayerView.stretch = true
		var newSubViewport = SubViewport.new()
		newSubViewport.add_child(Camera2D.new())
		if (player == 1):
			newSubViewport.add_child(levelNode)
			newSubViewport.world_2d = levelNode
			world_2d = newSubViewport.world_2d
		else:
			newSubViewport.world_2d = world_2d
		newPlayerView.add_child(newSubViewport)
		
			
		$VBoxContainer.add_child(newPlayerView)

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	# Reload the scene
	if Input.is_action_just_pressed("debug_reload"):
		print("[DEBUG] Reloaded scene!")
		get_tree().reload_current_scene()
		

func _on_world_boundary_body_exited(body):
	if (body.is_in_group("Character")):
		#print("OOB:", body.name)
		body.perish()
		if (body.name == "Enemy"):
			increment_score.emit()
		if (body.name == "Player"):
			game_over.emit()
