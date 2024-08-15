extends CanvasLayer

@export var is_coop_mode : bool = false

var current_score = 0
var game_is_over = false

func increase_score(amount):
	current_score += amount
	update_score()

func update_score():
	if game_is_over:
		return
	$Score.text = " Spubbs bested: {score}".format({"score":current_score})

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_coop_mode:
		$Score.show()
	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_increment_score():
	print("slain a spubb!!!")
	increase_score(1)


func _on_main_game_over():
	$Game_Over.show()
	_prompt_game_over()
	


func _on_main_player_died(player_num):
	if game_is_over:
		return
	# Only called in 2 player mode
	_prompt_game_over()
	if player_num == 2:
		$Player1Victory.show()
	else:
		$Player2Victory.show()


func _prompt_game_over():
	print("Game over!")
	game_is_over = true
	$RestartPrompt.show()
