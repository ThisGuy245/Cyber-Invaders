extends Node

var player_name = ""
var player_score = 0
var difficulty_level: int = 0
var enemy_type: String = ""
var Lives = 3
var is_paused: bool = false

var score = 0
var Q_asked = 0
var Q_correct = 0

var shots_fired = 0
var shots_hit = 0
var bombs_hit = 0
var levels_completed = 0
var difficulty_chosen = ""  # This needs to be set before the quiz starts

# Difficulty-related variables
var invader_speed = 1.5  # Initial invader speed for easy mode
var shot_timer_speed = 3.0  # Initial shot timer speed for easy mode
var bomb_chance = 10  # Initial bomb drop chance (percentage)
var laser_speed = 400  # Adjust this based on your game
var invader_shot_speed = 200  # Speed of invader shots

# Leaderboard array
var leaderboard = []

# Tracks which invaders are alive
var invader_alive_grid = []  # 2D array to store the alive status of invaders

signal game_over
signal pause_game()
signal resume_game()
signal on_points_increased(points: int)

func _ready():
	# Initialize the invader grid to keep track of invader states
	for row in range(5):  # Adjust this based on the number of rows
		var row_list = []
		for col in range(11):  # Adjust this based on the number of columns
			row_list.append(true)  # All invaders are alive initially
		invader_alive_grid.append(row_list)

# Check if the invader at the specified row and column is alive
func is_invader_alive(row: int, col: int) -> bool:
	if row >= 0 and row < invader_alive_grid.size() and col >= 0 and col < invader_alive_grid[row].size():
		return invader_alive_grid[row][col]
	return false

# Record when an invader is killed (mark the position as dead)
func record_invader_dead(row: int, col: int):
	if row >= 0 and row < invader_alive_grid.size() and col >= 0 and col < invader_alive_grid[row].size():
		invader_alive_grid[row][col] = false

# Record when an invader is spawned/alive
func record_invader_alive(row: int, col: int):
	if row >= 0 and row < invader_alive_grid.size() and col >= 0 and col < invader_alive_grid[row].size():
		invader_alive_grid[row][col] = true

func add_score(name, score):
	leaderboard.append({"name": name, "score": score})
	leaderboard.sort_custom(Callable(self, "_sort_by_score"))

func _sort_by_score(a, b):
	return b["score"] - a["score"]

func set_pause_state(pause: bool):
	is_paused = pause
	if is_paused:
		emit_signal("pause_game")
	else:
		emit_signal("resume_game")

# Function to save updated difficulty settings
func save_difficulty_settings(new_invader_speed: float, new_shot_timer_speed: float, new_bomb_chance: float):
	invader_speed = new_invader_speed
	shot_timer_speed = new_shot_timer_speed
	bomb_chance = new_bomb_chance
	print("Difficulty settings updated:")
	print("Invader Speed: ", invader_speed)
	print("Shot Timer Speed: ", shot_timer_speed)
	print("Bomb Chance: ", bomb_chance)

func reset_game():
	player_name = ""
	player_score = 0
	difficulty_level = 0
	enemy_type = ""
	Lives = 3
	leaderboard.clear()
	shots_fired = 0
	shots_hit = 0
	bombs_hit = 0
	levels_completed = 0
	difficulty_chosen = ""

	# Reset invader alive grid
	invader_alive_grid.clear()
	for row in range(5):
		var row_list = []
		for col in range(11):
			row_list.append(true)
		invader_alive_grid.append(row_list)
