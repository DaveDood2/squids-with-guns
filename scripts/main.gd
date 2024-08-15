extends Node2D

@export var two_player_coop_scene : PackedScene
@export var two_player_versus_scene : PackedScene
@export var credits_scene : PackedScene
@export var main_menu_scene : PackedScene
@export var current_level : Node2D

signal increment_score
signal game_over
signal player_died

var playerCount = 2
var livingPlayers = playerCount

func _ready():
	if (get_tree().current_scene.name == "Title Screen"):
		return
	get_viewport().transparent_bg = true
	var world_2d = $VBoxContainer/playerView/SubViewport.world_2d
	for player in range(1, playerCount + 1):
		var currentPlayer = get_tree().get_nodes_in_group("level")[0].get_node("Player" + str(player))
		if (player == 1):
			currentPlayer.get_node("RemoteTransform2D").set_remote_node($VBoxContainer/playerView/SubViewport/Camera2D.get_path())
		else: # player 2 and onwards...
			var newPlayerView = SubViewportContainer.new()
			newPlayerView.stretch = true
			newPlayerView.size_flags_vertical = Control.SIZE_EXPAND_FILL
			var newSubViewport = SubViewport.new()
			var newCamera = Camera2D.new()
			newSubViewport.add_child(newCamera)
			newSubViewport.world_2d = world_2d
			newSubViewport.audio_listener_enable_2d = true
			newPlayerView.add_child(newSubViewport)
			$VBoxContainer.add_child(newPlayerView)
			currentPlayer.get_node("RemoteTransform2D").set_remote_node(newCamera.get_path())


# Called when the node enters the scene tree for the first time.
func _process(_delta):
	# Reload the scene
	if Input.is_action_just_pressed("debug_reload"):
		print("[DEBUG] Reloaded scene!")
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("debug_close_game"):
		#if (get_tree().current_scene.name != "Title Screen"):
			#get_tree().change_scene_to_packed(main_menu_scene)
		#else:
			print("[DEBUG] Closing game!")
			get_tree().quit()
		


func _on_world_boundary_body_exited(body):
	if (body.is_in_group("Character")):
		print("OOB:", body.name)
		body.perish()
		if (body.is_in_group("Enemy")):
			increment_score.emit()
		if (body.is_in_group("Player")):
			livingPlayers -= 1
			player_died.emit(body.player_num)
			if livingPlayers <= 0:	
				game_over.emit()
			


func _on_one_player_pressed():
	get_tree().change_scene_to_packed(two_player_coop_scene)


func _on_two_player_pressed():
	get_tree().change_scene_to_packed(two_player_versus_scene)


func _on_credits_help_pressed():
	get_tree().change_scene_to_packed(credits_scene)


func _on_exit_game_pressed():
	get_tree().quit()
