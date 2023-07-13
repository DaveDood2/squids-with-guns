extends CanvasLayer

var current_score = 0

func increase_score(amount):
	current_score += amount
	update_score()

func update_score():
	$Score.text = "Spubbs bested: {score}".format({"score":current_score})
	
func _on_character_died(team):
	print("Died:", team)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
