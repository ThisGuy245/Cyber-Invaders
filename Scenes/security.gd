extends Area2D
class_name Security

@export var speed: float = 300.0

signal quiz

var is_moving: bool = true

func _ready():
	print("Security bot ready")
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	if is_moving:
		global_position.x += speed * delta

func _on_area_entered(area):
	if area is Player:
		quiz_player()

func quiz_player():
	# Stop the bot's movement
	is_moving = false
	print("Player encountered by security bot!")
	emit_signal("quiz")
	Global.set_pause_state(true)
	# Add a timer to show some text in the UI before sending the player to the education room
	var timer = Timer.new()
	timer.wait_time = 2.0 # Adjust the wait time as needed
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_quiz_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_quiz_timer_timeout():
	Global.set_pause_state(true)  # Emitting 'pause_game' signal if needed
	
	emit_signal("quiz_started")
	get_tree().change_scene_to_file("res://input2.tscn")  # Replace current scene with quiz scene
