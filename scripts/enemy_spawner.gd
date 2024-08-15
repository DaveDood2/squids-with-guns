extends Path2D

signal enemy_spawned(enemy)

var move_speed = 100
@export var enemy: PackedScene
@export var max_enemies := 8
var spawn_frequency := 20.0
var min_spawn_frequency := 2.0
var spawn_frequency_modifier := 0.9
var current_spawn_time := 0.0
var spawner_active = false
var active_enemies := 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (spawner_active):
		$PathFollow2D.progress += delta * move_speed
		if active_enemies < max_enemies:
			current_spawn_time -= delta
		if current_spawn_time <= 0:
			spawn_enemy()
			current_spawn_time += spawn_frequency
			active_enemies += 1
			spawn_frequency = maxf(spawn_frequency * spawn_frequency_modifier, min_spawn_frequency)

func spawn_enemy():
	print("A new spubb is born")
	var new_enemy = enemy.instantiate()
	new_enemy.position = $PathFollow2D.global_position
	
	get_parent().add_child(new_enemy)
	enemy_spawned.emit(new_enemy)


func _on_main_increment_score():
	active_enemies -= 1
	if (active_enemies <= 0):
		current_spawn_time = 0
	spawner_active = true
