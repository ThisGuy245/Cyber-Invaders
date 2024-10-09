extends Control

@onready var button = $Button
@onready var questions_label = $Questions
@onready var score_label = $Score
@onready var assessment_label = $Assessment

func _ready():
	button.connect("pressed", Callable(self, "_on_button_pressed"))
	update_labels()

func _on_button_pressed():
	print("Restart")

	# Appelle la fonction reset_game depuis le script global
	var global_node = get_tree().root.get_node("Global")
	global_node.reset_game()

	# Recharge la scène de départ
	get_tree().change_scene_to_file("res://start_screen.tscn")

func update_labels():
	var global_node = get_tree().root.get_node("Global")
	var score = global_node.player_score
	var q_correct = global_node.Q_correct
	var q_asked = global_node.Q_asked

	score_label.text = "Final Score: %d" % score
	questions_label.text = "Questions Answered: %d/%d" % [q_correct, q_asked]
	assessment_label.text = "Assessment: %s" % get_assessment(q_correct, q_asked, score)

func get_assessment(q_correct, q_asked, score):
	var assessment = ""
	var color = Color.WHITE

	if q_correct >= 10:
		assessment = "Excellent"
		color = Color(0.4, 0.0, 1.0)  # Blue
	elif q_correct >= 5:
		assessment = "Good"
		color = Color(0.0, 1.0, 0.0)  # Green
	elif q_correct >= 1:
		assessment = "Poor"
		color = Color(1.0, 0.5, 0.0)  # Orange
	else:
		assessment = "Horrible"
		color = Color(1.0, 0.0, 0.0)  # Red

	if score >= 1000:
		assessment = "Amazing"
		color = Color(0.5, 0.0, 0.5)  # Purple
	elif score >= 500:
		assessment = "Good"
		color = Color(0.0, 1.0, 0.0)  # Green
	elif score >= 100:
		assessment = "Poor"
		color = Color(1.0, 0.5, 0.0)  # Orange
	else:
		assessment = "Horrible"
		color = Color(1.0, 0.0, 0.0)  # Red

	assessment_label.text = "Assessment: %s" % assessment
	assessment_label.modulate = color
	return assessment
