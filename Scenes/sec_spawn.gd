extends Node2D

@export var security_bot_scene: PackedScene
@export var points_threshold: int = 400
var invaders_killed: int = 0
var bot_spawned: bool = false

@onready var global = get_node("/root/Global") as Global

func _ready():
	if global:
		global.connect("on_points_increased", Callable(self, "on_points_earned"))
	else:
		print("Global node not found")

func _process(delta):
	if not bot_spawned and (global.player_score >= points_threshold):
		print("Conditions met for spawning security bot")
		spawn_security_bot()
		global.player_score = 0
		bot_spawned = true

func on_invader_killed():
	invaders_killed += 1
	print("Invader killed. Total invaders killed: ", invaders_killed)

func on_points_earned(points: int):
	global.player_score += points
	print("Points earned. Player points: ", global.player_score)
	if global.player_score >= points_threshold:
		print("Player points threshold reached")
		spawn_security_bot()
		global.player_score = 0

func spawn_security_bot():
	print("Spawning security bot")
	var security_bot = security_bot_scene.instantiate()
	security_bot.global_position = Vector2(-600, 250) # Adjust the spawn position as needed
	add_child(security_bot)
