extends Node2D

signal character_left_bounds(body)

func _on_world_boundary_body_exited(body):
	if not body.is_in_group("Character"):
		return
	character_left_bounds.emit(body)
	if body.is_in_group("Enemy") and $EnemySpawner:
		$EnemySpawner._on_main_increment_score()


func _on_enemy_spawner_enemy_spawned(enemy):
	enemy.perished.connect(_on_world_boundary_body_exited)
