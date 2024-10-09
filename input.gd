extends Control

@onready var name_input = $LineEdit
@onready var play_button = $Button

# Reference to the TextureRect nodes for buttons
@onready var easy_button_texture = $"Easy B/TextureRect"
@onready var inter_button_texture = $"Inter B/TextureRect"
@onready var prof_button_texture = $"Prof B/TextureRect"

# Load textures for each button state
@onready var easy_button_normal = preload("res://Assets/Invaders/Invader3-1.png")
@onready var easy_button_greyscale = preload("res://Assets/font/Invader3-G.png")
@onready var inter_button_normal = preload("res://Assets/Invaders/Invader2-1.png")
@onready var inter_button_greyscale = preload("res://Assets/font/Invader2-G.png")
@onready var prof_button_normal = preload("res://Assets/Invaders/Invader1-1.png")
@onready var prof_button_greyscale = preload("res://Assets/font/Invader1-G.png")

var selected_difficulty = 0  # 0 for easy, 1 for intermediate, 2 for professional

func _ready():
	# Connect button signals
	$"Easy B".connect("pressed", Callable(self, "_on_easy_button_pressed"))
	$"Inter B".connect("pressed", Callable(self, "_on_inter_button_pressed"))
	$"Prof B".connect("pressed", Callable(self, "_on_prof_button_pressed"))
	play_button.connect("pressed", Callable(self, "_on_button_pressed"))

	# Initialize buttons to greyscale
	set_button_state(easy_button_texture, true)
	set_button_state(inter_button_texture, false)
	set_button_state(prof_button_texture, false)

	# Set initial state of the Play button
	set_play_button_state()

	# Connect LineEdit text_changed signal
	name_input.connect("text_changed", Callable(self, "_on_name_input_changed"))

func _on_easy_button_pressed():
	print("PRESSED")
	set_button_state(easy_button_texture, true)
	set_button_state(inter_button_texture, false)
	set_button_state(prof_button_texture, false)
	selected_difficulty = 0
	set_play_button_state()

func _on_inter_button_pressed():
	print("PRESSED")
	set_button_state(easy_button_texture, false)
	set_button_state(inter_button_texture, true)
	set_button_state(prof_button_texture, false)
	selected_difficulty = 1
	set_play_button_state()

func _on_prof_button_pressed():
	print("PRESSED")
	set_button_state(easy_button_texture, false)
	set_button_state(inter_button_texture, false)
	set_button_state(prof_button_texture, true)
	selected_difficulty = 2
	set_play_button_state()

func set_button_state(texture_rect: TextureRect, is_selected: bool):
	if texture_rect == easy_button_texture:
		texture_rect.texture = easy_button_normal if is_selected else easy_button_greyscale
	elif texture_rect == inter_button_texture:
		texture_rect.texture = inter_button_normal if is_selected else inter_button_greyscale
	elif texture_rect == prof_button_texture:
		texture_rect.texture = prof_button_normal if is_selected else prof_button_greyscale

func set_play_button_state():
	if name_input.text.strip_edges() != "" and selected_difficulty != null:
		play_button.modulate = Color(1, 0.5, 0)  # Orange color
		play_button.disabled = false
	else:
		play_button.modulate = Color(0.5, 0.5, 0.5)  # Grey color
		play_button.disabled = true

func _on_name_input_changed(new_text):
	set_play_button_state()


func _on_button_pressed():
	var player_name = name_input.text
	if player_name.length() <= 10:
		# Store the player's name and difficulty in a global variable
		var global_node = get_tree().root.get_node("Global")
		global_node.player_name = player_name
		global_node.difficulty_level = selected_difficulty  # Set difficulty level
		# Start the game
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	else:
		# Display an error or prompt the user to enter a valid name
		pass
	print(player_name)
