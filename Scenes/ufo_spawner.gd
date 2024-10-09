extends Node2D

@onready var ufo_spawn_timer = $SpawnTimer
@export var ufo_scene: PackedScene
@export var bomb_scene: PackedScene  # Ensure this line is present

var current_ufo: Node2D = null

func _ready():
	Global.connect("pause_game", Callable(self, "_on_pause_game"))
	Global.connect("resume_game", Callable(self, "_on_resume_game"))
	randomize()
	ufo_spawn_timer.wait_time = randf_range(8, 12)
	ufo_spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	ufo_spawn_timer.start()

func _on_SpawnTimer_timeout():
	if Global.is_paused:
		return

	if current_ufo == null:
		spawn_ufo()

	ufo_spawn_timer.wait_time = randf_range(8, 12)
	ufo_spawn_timer.start()

func spawn_ufo():
	var ufo = ufo_scene.instantiate()
	if ufo:
		var start_position: Vector2
		if randi() % 2 == 0:
			start_position = Vector2(-500, -260)
		else:
			start_position = Vector2(get_viewport().size.x, -260)
		
		ufo.global_position = start_position
		get_tree().root.add_child(ufo)
		current_ufo = ufo
		ufo.connect("tree_exited", Callable(self, "_on_ufo_exited"))

		# Add the bomb as a child of the UFO
		var bomb = bomb_scene.instantiate()
		if bomb:
			bomb.position = ufo.position + Vector2(0, 50)  # Adjust the position as needed
			ufo.add_child(bomb)

func _on_ufo_exited():
	if current_ufo and current_ufo.is_in_group("ufo"):
		current_ufo = null

func _on_pause_game():
	ufo_spawn_timer.stop()

func _on_resume_game():
	current_ufo = null
	randomize()
	ufo_spawn_timer.wait_time = randf_range(8, 12)
	ufo_spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	ufo_spawn_timer.start()
	spawn_ufo()  # Immediately spawn a new UFO when the game resumes
