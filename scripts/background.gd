extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	$ParallaxLayer/AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
