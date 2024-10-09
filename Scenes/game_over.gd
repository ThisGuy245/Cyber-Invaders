extends CanvasLayer

@onready var virus_label = $VirusLabel
@onready var desc_label = $DescLabel
@onready var restart_button = $RestartButton
@onready var home_button = $HomeButton  # Reference to the HomeButton node
@onready var enemy_image = $EnemyImage
@onready var text_change_timer = $TextChangeTimer

var enemy_images = {
	"Trojan Virus": preload("res://Assets/Invaders/Invader3-1.png"),
	"Spyware": preload("res://Assets/Invaders/Invader1-1.png"),
	"Malware": preload("res://Assets/Invaders/Invader2-1.png"),
	"Unknown Virus": preload("res://Assets/Ufo/Ufo.png"),
}

var enemy_descriptions = {
	"Trojan Virus": "A Trojan virus disguises itself as legitimate software to deceive users into installing it.",
	"Spyware": "Spyware secretly gathers information about users while they browse the internet or use applications.",
	"Malware": "Malware is malicious software designed to harm, exploit, or compromise a computer system.",
	"Unknown Virus": "An unknown type of virus has caused the game over. Please consult your system administrator for more information."
}

var game_over_shown = false
var decrypting_stage = 0

func _ready():
	restart_button.connect("pressed", Callable(self, "on_restart_button_press"))
	home_button.connect("pressed", Callable(self, "on_home_button_press"))  # Connect HomeButton signal
	text_change_timer.connect("timeout", Callable(self, "on_text_change_timer_timeout"))
	restart_button.disabled = true
	restart_button.text = "Decrypting"
	restart_button.modulate = Color(0.0, 1.0, 0.0)  # Green color

func show_game_over():
	var enemy_types = ["Trojan Virus", "Spyware", "Malware", "Unknown Virus"]
	var random_index = randi() % enemy_types.size()
	var enemy_type = enemy_types[random_index]
	print("Selected enemy type:", enemy_type)
	virus_label.text = enemy_type

	if enemy_images.has(enemy_type):
		var enemy_texture = enemy_images[enemy_type]
		if enemy_texture:
			enemy_image.texture = enemy_texture
		else:
			print("Enemy texture is null for enemy type:", enemy_type)
	else:
		enemy_image.texture = null
		print("Couldn't find image for enemy type:", enemy_type)

	if enemy_descriptions.has(enemy_type):
		desc_label.text = enemy_descriptions[enemy_type]
	else:
		desc_label.text = "An unknown type of virus has caused the game over. Please consult your system administrator for more information."

	text_change_timer.start()
	game_over_shown = true 

func on_restart_button_press():
	get_tree().reload_current_scene()

func on_home_button_press():
	# Load the initial scene, replace with your actual initial scene path
	get_tree().change_scene_to_file("res://start_screen.tscn")

func on_text_change_timer_timeout():
	if game_over_shown:
		match decrypting_stage:
			0: restart_button.text = "Decrypting."
			1: restart_button.text = "Decrypting.."
			2: restart_button.text = "Decrypting..."
			3:
				restart_button.text = "RESTART GAME"
				restart_button.modulate = Color(0.91, 0.26, 0.0)  # Orange color
				restart_button.disabled = false
				text_change_timer.stop()
				game_over_shown = false
			_:
				print("Invalid decrypting stage")
		
		decrypting_stage = (decrypting_stage + 1) % 4
