extends Control

@onready var scene_node: CharacterBody2D = $CharacterBody2D

@onready var option_a_button: Button = $OptionA
@onready var option_b_button: Button = $OptionB
@onready var option_c_button: Button = $OptionC

@onready var question_label: Label = $EnemyImage/VirusLabel/DescLabel
@onready var result_label: Label = $Label
@onready var timer: Timer = $TextChangeTimer

signal quiz_completed(success: bool)  # Signal to notify LifeManager of quiz completion

var quiz_data = [
	{
		"question": "What is the primary goal of cybersecurity?",
		"answers": ["To protect information", "To hack systems", "To create\n software"],
		"correct_answer": "To protect information"
	},
	{
		"question": "What does a firewall do?",
		"answers": ["Blocks unauthorized access", "Creates viruses", "Encrypts data"],
		"correct_answer": "Blocks unauthorized access"
	},
	{
		"question": "What is phishing?",
		"answers": ["A method to steal information", "A software update", "A type of encryption"],
		"correct_answer": "A method to steal information"
	},
	{
		"question": "What does HTTPS stand for?",
		"answers": ["Hypertext Transfer\n Protocol Secure", "Hypertext Transfer\n Protocol Simple", "Hyper Transfer\n Secure"],
		"correct_answer": "Hypertext Transfer Protocol Secure"
	},
	{
		"question": "What is a strong password?",
		"answers": ["A combination\n of letters, \nnumbers, and symbols", "Just letters", "A simple word"],
		"correct_answer": "A combination of letters, numbers, and symbols"
	},
	{
		"question": "What is malware?",
		"answers": ["Malicious software", "An antivirus program", "A firewall"],
		"correct_answer": "Malicious software"
	}
]

var selected_question



func _ready():
	$OptionA.connect("pressed", Callable(self, "_on_option_a_pressed"))
	$OptionB.connect("pressed", Callable(self, "_on_option_b_pressed"))
	$OptionC.connect("pressed", Callable(self, "_on_option_c_pressed"))

func _on_option_a_pressed():
	print("Option A Button Pressed")

func _on_option_b_pressed():
	print("Option B Button Pressed")

func _on_option_c_pressed():
	print("Option C Button Pressed")

