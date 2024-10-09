extends Area2D

class_name InvaderShot

@export var speed = 200

signal enemy_shot(enemy_type: String)

var enemy_type: String  # Variable to store the enemy type
var is_shot_paused = false  # Track if the shot is paused

func _ready():
	Global.connect("pause_game", Callable(self, "_on_pause_game"))
	Global.connect("resume_game", Callable(self, "_on_resume_game"))
	speed = Global.invader_shot_speed  # Adjust shot speed based on difficulty

func _process(delta):
	if not is_shot_paused:
		position.y += speed * delta  # Move the shot only when not paused

	# If the game is paused globally, prevent movement but don't queue_free
	if Global.is_paused:
		return

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Player:
		(area as Player).on_player_destroyed()
		queue_free()
		emit_signal("enemy_shot", enemy_type)  # Emit signal with enemy_type

func _on_pause_game():
	is_shot_paused = true  # Pause the shot without freeing it

func _on_resume_game():
	is_shot_paused = false  # Resume the shot's movement when the game resumes
