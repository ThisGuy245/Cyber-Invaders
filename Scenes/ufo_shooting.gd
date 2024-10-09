extends Node2D

@export var projectile_scene: PackedScene
@onready var spawn_timer: Timer = $SpawnTimer

var rounds_left = 4

func _ready():
	Global.connect("pause_game", Callable(self, "_on_pause_game"))
	Global.connect("resume_game", Callable(self, "_on_resume_game"))
	spawn_timer.one_shot = true
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))

func _on_spawn_timer_timeout():
	if Global.is_paused:
		return

	if rounds_left > 0:
		spawn_ddos_round()
		rounds_left -= 1

func spawn_ddos_round():
	if Global.is_paused:
		return

	for i in range(24):
		var projectile = projectile_scene.instantiate()
		if projectile:
			projectile.global_position = global_position + Vector2(i * 10, 0)
			get_tree().root.add_child(projectile)
	spawn_timer.one_shot = true

func start_shooting(rounds: int):
	rounds_left = rounds
	spawn_timer.start(1.0)

func _on_pause_game():
	queue_free()
	spawn_timer.stop()

func _on_resume_game():
	spawn_timer.start()
