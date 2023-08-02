extends Path2D


var move_speed = 100
@export var enemy: PackedScene
var spawn_frequency := 30.0
var min_spawn_frequency := 2.0
var spawn_frequency_modifier := 0.8
var current_spawn_time := 0.0
var spawner_active = false
var active_enemies := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (spawner_active):
		$PathFollow2D.progress += delta * move_speed
		current_spawn_time -= delta
		if (current_spawn_time <= 0):
			spawn_enemy()
			current_spawn_time += spawn_frequency
			active_enemies += 1
			spawn_frequency = maxf(spawn_frequency * spawn_frequency_modifier, min_spawn_frequency)

func spawn_enemy():
	print("A new spubb is born")
	var new_enemy = enemy.instantiate()
	new_enemy.position = $PathFollow2D.position
	get_tree().get_current_scene().add_child(new_enemy)


func _on_main_increment_score():
	active_enemies -= 1
	if (active_enemies <= 0):
		current_spawn_time = 0
	spawner_active = true
