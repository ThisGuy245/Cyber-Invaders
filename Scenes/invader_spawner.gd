extends Node2D
class_name InvaderSpawner
signal invader_destroyed(points: int)
signal game_won
signal game_lost

const ROWS = 5
const COLUMNS = 11
const HORIZONTAL_SPACING = 54
const VERTICAL_SPACING = 28
const INVADER_HEIGHT = 24

var difficulty_level = 1

var movement_direction = 1  # 1 = right, -1 = left

@onready var movement_timer: Timer = $MovementTimer
@onready var shot_timer: Timer = $ShotTimer

var invader_scene = preload("res://Scenes/invader.tscn")
var invader_shot_scene = preload("res://Scenes/invader_shot.tscn")

# Track alive invaders
var alive_invaders = {}

var current_score = 0
const SCORE_THRESHOLD = 50  # Set threshold to 50 points

# Bomb-related variables
var bomb_scene = preload("res://bomb.tscn")
var bomb_chance = 20
var current_bomb: Bomb = null

func _ready():
	Global.connect("pause_game", Callable(self, "_on_pause_game"))
	Global.connect("resume_game", Callable(self, "_on_resume_game"))

	movement_timer.timeout.connect(move_invaders)
	shot_timer.timeout.connect(on_invader_shoot)

	# Retrieve difficulty settings from Global node
	difficulty_level = Global.difficulty_level
	bomb_chance = Global.bomb_chance
	movement_timer.wait_time = Global.invader_speed
	shot_timer.wait_time = Global.shot_timer_speed

	# Spawn invaders
	spawn_invaders()

func spawn_invaders():
	var invader_1_res = preload("res://Resources/invader_1.tres")
	var invader_2_res = preload("res://Resources/invader_2.tres")
	var invader_3_res = preload("res://Resources/invader_3.tres")

	for row in range(ROWS):
		var invader_config
		if row == 0:
			invader_config = invader_1_res
		elif row == 1 or row == 2:
			invader_config = invader_2_res
		elif row == 3 or row == 4:
			invader_config = invader_3_res

		var start_x_position = (position.x - (COLUMNS * HORIZONTAL_SPACING)) / 2

		for col in range(COLUMNS):
			if Global.is_invader_alive(row, col):
				var x = start_x_position + (col * HORIZONTAL_SPACING)
				var y = row * (INVADER_HEIGHT + VERTICAL_SPACING)
				spawn_invader(invader_config, Vector2(x, y), row, col)

func spawn_invader(invader_config, spawn_position: Vector2, row: int, col: int):
	var invader = invader_scene.instantiate() as Invader
	invader.config = invader_config
	invader.global_position = spawn_position
	invader.row = row
	invader.column = col
	invader.connect("invader_destroyed", Callable(self, "on_invader_destroyed"))  # Fixed signal connection
	add_child(invader)
	alive_invaders[invader] = spawn_position
	Global.record_invader_alive(row, col)


func on_invader_destroyed(invader: Invader, points: int):
	emit_signal("invader_destroyed", points)
	Global.record_invader_dead(invader.row, invader.column)
	alive_invaders.erase(invader)

	current_score += points

	# Increase difficulty based on score threshold (every 50 points)
	if current_score >= (difficulty_level + 1) * SCORE_THRESHOLD:
		difficulty_level += 1
		increase_difficulty()

	if alive_invaders.size() == 0:
		emit_signal("game_won")
		movement_timer.stop()
		shot_timer.stop()

func move_invaders():
	position.x += 10 * movement_direction  # Example movement speed, adjust as necessary

func _on_right_wall_area_entered(_area):
	if movement_direction == 1:
		position.y += 20
		movement_direction = -1

func _on_left_wall_area_entered(_area):
	if movement_direction == -1:
		position.y += 20
		movement_direction = 1

func on_invader_shoot():
	var invader_positions = alive_invaders.keys().map(func(invader): return invader.global_position)
	if invader_positions.size() > 0:
		var random_position = invader_positions.pick_random()
		var invader_shot = invader_shot_scene.instantiate() as InvaderShot
		invader_shot.global_position = random_position
		get_tree().root.get_node("main").add_child(invader_shot)

func increase_difficulty():
	# Increase difficulty more drastically early on, then smooth out.
	if difficulty_level <= 3:
		# Early stages: significant increase
		movement_timer.wait_time = max(0.05, movement_timer.wait_time - 0.2)
		shot_timer.wait_time = max(0.3, shot_timer.wait_time - 0.2)
	else:
		# Later stages: smoother and smaller increments
		movement_timer.wait_time = max(0.01, movement_timer.wait_time - 0.05)
		shot_timer.wait_time = max(0.1, shot_timer.wait_time - 0.05)
	
	bomb_chance = min(50, bomb_chance + 5)  # Cap bomb chance at 50%

	Global.save_difficulty_settings(movement_timer.wait_time, shot_timer.wait_time, bomb_chance)


	# Optionally, spawn a bomb with increased frequency
	if randi() % 100 < bomb_chance and current_bomb == null:
		spawn_bomb()

func spawn_bomb():
	if alive_invaders.size() > 0:
		var random_invader = alive_invaders.keys().pick_random()
		var bomb = bomb_scene.instantiate() as Bomb
		bomb.global_position = random_invader.global_position
		add_child(bomb)
		current_bomb = bomb

func _on_pause_game():
	movement_timer.stop()
	shot_timer.stop()

func _on_resume_game():
	movement_timer.start()
	shot_timer.start()
