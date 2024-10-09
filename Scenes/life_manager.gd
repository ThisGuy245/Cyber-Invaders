extends Node
class_name LifeManager

signal on_life_lost(lifes_left: int)
signal quiz_started()

@onready var player: Player = $"../Player"
@onready var player_scene = preload("res://Scenes/player.tscn")
@onready var quiz_scene_path = "res://input2.tscn"  # Path to the quiz scene

func _ready():
	player.player_destroyed.connect(on_player_destroyed)
	connect("quiz_started", Callable(self, "_on_quiz_started"))

func on_player_destroyed():
	Global.Lives -= 1
	print("LIVES =", Global.Lives)
	emit_signal("on_life_lost", Global.Lives)
	
	if Global.Lives > 0:
		swap_to_quiz_scene()
	elif Global.Lives == 0:
		get_tree().change_scene_to_file("res://game_over.tscn")

# Swap the current scene to the quiz scene
func swap_to_quiz_scene():
	Global.set_pause_state(true)  # Emitting 'pause_game' signal if needed
	
	emit_signal("quiz_started")
	get_tree().change_scene_to_file(quiz_scene_path)  # Replace current scene with quiz scene

func _on_quiz_completed(success: bool):
	# Called when the quiz scene finishes
	Global.set_pause_state(false)  # Emitting 'resume_game' signal if needed
	
	if success:
		respawn_player()
	else:
		on_player_destroyed()

func _on_quiz_started():
	# If any preparation is needed before the quiz starts
	pass

# Function to respawn the player after quiz success
func respawn_player():
	player = player_scene.instantiate() as Player
	player.global_position = Vector2(0, 302)
	player.player_destroyed.connect(on_player_destroyed)
	get_tree().root.get_node("main").add_child(player)

	# Load the previous game scene
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")  # Example of returning to the main game scene
