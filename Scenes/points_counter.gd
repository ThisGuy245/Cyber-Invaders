extends Node 

class_name PointsCounter 

signal on_points_increased(points: int) 

var points = 0 

@onready var invader_spawner = get_node_or_null("/root/main/InvaderSpawner") as InvaderSpawner
@onready var ufo = get_node_or_null("/root/main/UfoSpawner/Ufo") as Node 
@onready var sec_spawner = get_node_or_null("/root/main/Security") as Node2D 
const level_complete_scene_path = "res://Scenes/level_complete.tscn" 
var level_complete 

func _ready():
	if invader_spawner:
		invader_spawner.connect("invader_destroyed", Callable(self, "_increase_points"), CONNECT_DEFERRED)
		invader_spawner.connect("game_won", Callable(self, "_on_game_won"), CONNECT_DEFERRED)
	else:
		print("InvaderSpawner node not found")

	if ufo:
		ufo.connect("invader_destroyed", Callable(self, "_increase_points"), CONNECT_DEFERRED)
	else:
		print("ufo node not found")

	level_complete = preload(level_complete_scene_path)

func _increase_points(points_to_add: int):
	points += points_to_add
	Global.player_score += points_to_add
	Global.score += points_to_add
	emit_signal("on_points_increased", Global.score)
	print("Points increased. Current points: ", Global.score)

func _on_game_won():
	print("Game Won! Transitioning to level complete menu.")
	level_complete
