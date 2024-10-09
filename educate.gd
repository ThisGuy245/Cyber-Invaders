extends Control

signal quiz_completed(success: bool)

@onready var A_button = $OptionA
@onready var B_button = $OptionB
@onready var C_button = $OptionC
@onready var A_text = $OptionA/RichTextLabel
@onready var B_text = $OptionB/RichTextLabel
@onready var C_text = $OptionC/RichTextLabel
@onready var result_label = $Label2
@onready var lives_container = $VBoxContainer
@onready var timer = $Timer
@onready var countdown_label = $Countdown

var life_texture = preload("res://Assets/Player/Player.png")
var life_lost_texture = preload("res://Assets/Player/Player-dead.png")

# Countdown timer settings
var countdown_time = 10  # Total countdown time in seconds

# Global variables for quiz
var max_lives = 3
var current_lives = max_lives
var selected_question

# Quiz data split by difficulty (15 questions each)
var easy_questions = [
	{"question": "What is the strongest password?", "answers": ["password123", "Qwerty123", "S3cuR3!P@ssw0rd"], "correct_answer": "S3cuR3!P@ssw0rd"},
	{"question": "What is phishing?", "answers": ["Email scam", "Online shopping", "Sending large files"], "correct_answer": "Email scam"},
	{"question": "What should you do if you receive a suspicious email?", "answers": ["Open it", "Delete it", "Forward it"], "correct_answer": "Delete it"},
	{"question": "What does a firewall do?", "answers": ["Blocks traffic", "Sends emails", "Opens websites"], "correct_answer": "Blocks traffic"},
	{"question": "What is two-factor authentication?", "answers": ["Password only", "Security question", "Extra security layer"], "correct_answer": "Extra security layer"},
	{"question": "What does HTTPS stand for?", "answers": ["Hyper Text Transfer Protocol Secure", "High Tech Transfer Protocol Security", "Hyperlink Tech Test Protocol"], "correct_answer": "Hyper Text Transfer Protocol Secure"},
	{"question": "What should you avoid doing on public Wi-Fi?", "answers": ["Checking social media", "Online banking", "Watching videos"], "correct_answer": "Online banking"},
	{"question": "What is malware?", "answers": ["Malicious software", "Anti-virus", "Hardware"], "correct_answer": "Malicious software"},
	{"question": "Which one is a strong password?", "answers": ["password", "1Q2w3e4r", "John1990"], "correct_answer": "1Q2w3e4r"},
	{"question": "What should you do if your password is compromised?", "answers": ["Ignore it", "Change it", "Use it for other accounts"], "correct_answer": "Change it"},
	{"question": "What is ransomware?", "answers": ["Locks files for payment", "Email scam", "Browser extension"], "correct_answer": "Locks files for payment"},
	{"question": "What is a VPN?", "answers": ["Virtual Private Network", "Visual Private Network", "Virtual Personal Network"], "correct_answer": "Virtual Private Network"},
	{"question": "What should you do before downloading an app?", "answers": ["Check reviews", "Install it", "Ignore warnings"], "correct_answer": "Check reviews"},
	{"question": "What is a CAPTCHA used for?", "answers": ["Verify human users", "Collect data", "Install software"], "correct_answer": "Verify human users"},
	{"question": "What is spyware?", "answers": ["Software that spies on users", "A type of anti-virus", "Hardware device"], "correct_answer": "Software that spies on users"}
]

var medium_questions = [
	{"question": "What does encryption do?", "answers": ["Protects data by scrambling", "Destroys data", "Deletes viruses"], "correct_answer": "Protects data by scrambling"},
	{"question": "What is a DDoS attack?", "answers": ["Overloading a server with requests", "Sending phishing emails", "Downloading malware"], "correct_answer": "Overloading a server with requests"},
	{"question": "What does the term 'zero-day' refer to?", "answers": ["A software vulnerability unknown to the vendor", "Day when a system goes offline", "The first day of a new system launch"], "correct_answer": "A software vulnerability unknown to the vendor"},
	{"question": "What is social engineering?", "answers": ["Manipulating people to reveal confidential information", "Building secure systems", "Encrypting personal data"], "correct_answer": "Manipulating people to reveal confidential information"},
	{"question": "Which protocol ensures encrypted web traffic?", "answers": ["HTTPS", "HTTP", "FTP"], "correct_answer": "HTTPS"},
	{"question": "Which of these is NOT a type of malware?", "answers": ["Trojan", "Firewall", "Spyware"], "correct_answer": "Firewall"},
	{"question": "What is the role of an anti-virus program?", "answers": ["Detect and remove malware", "Increase CPU speed", "Improve internet speed"], "correct_answer": "Detect and remove malware"},
	{"question": "What is a brute-force attack?", "answers": ["Attempting many passwords", "Sending phishing emails", "Downloading malware"], "correct_answer": "Attempting many passwords"},
	{"question": "What is a keylogger?", "answers": ["Software that records keystrokes", "Anti-virus program", "Firewall component"], "correct_answer": "Software that records keystrokes"},
	{"question": "What should you do when a website asks for sensitive information?", "answers": ["Check for HTTPS", "Ignore it", "Close the browser"], "correct_answer": "Check for HTTPS"},
	{"question": "What is spear phishing?", "answers": ["Targeted phishing attack", "Spam emails", "Broadcast scam emails"], "correct_answer": "Targeted phishing attack"},
	{"question": "Which is a sign of a compromised system?", "answers": ["Slow performance", "Running many applications", "Using a VPN"], "correct_answer": "Slow performance"},
	{"question": "What is patch management?", "answers": ["Updating software to fix vulnerabilities", "Creating new malware", "Adding new features to software"], "correct_answer": "Updating software to fix vulnerabilities"},
	{"question": "What is a rootkit?", "answers": ["Malware that hides its existence", "Tool for encrypting files", "Firewall component"], "correct_answer": "Malware that hides its existence"},
	{"question": "What is a security audit?", "answers": ["Review of a system's security", "Installing new software", "Deleting unused files"], "correct_answer": "Review of a system's security"}
]
var hard_questions = [
	{"question": "What is an Advanced Persistent Threat (APT)?", "answers": ["Long-term targeted attack", "Random malware infection", "Brute-force attack"], "correct_answer": "Long-term targeted attack"},
	{"question": "What does multi-factor authentication enhance?", "answers": ["Account security", "Software performance", "System memory"], "correct_answer": "Account security"},
	{"question": "Which encryption algorithm is considered secure?", "answers": ["AES-256", "MD5", "SHA-1"], "correct_answer": "AES-256"},
	{"question": "What is the main purpose of penetration testing?", "answers": ["Find vulnerabilities", "Install security patches", "Encrypt files"], "correct_answer": "Find vulnerabilities"},
	{"question": "What is the principle of least privilege?", "answers": ["Limiting access rights for users", "Giving full control to all users", "Providing admin rights to everyone"], "correct_answer": "Limiting access rights for users"},
	{"question": "What is a honeypot?", "answers": ["Decoy system to lure attackers", "A database", "A security patch"], "correct_answer": "Decoy system to lure attackers"},
	{"question": "Which of these is a common hashing algorithm?", "answers": ["SHA-256", "AES", "SSL"], "correct_answer": "SHA-256"},
	{"question": "What does XSS stand for?", "answers": ["Cross-Site Scripting", "XML Secure System", "Cross-Site Stealing"], "correct_answer": "Cross-Site Scripting"},
	{"question": "What is SQL Injection?", "answers": ["Exploiting database vulnerabilities", "Breaking into websites", "Encrypting databases"], "correct_answer": "Exploiting database vulnerabilities"},
	{"question": "What is the purpose of a digital certificate?", "answers": ["Verify the authenticity of a website or user", "Encrypt files", "Detect malware"], "correct_answer": "Verify the authenticity of a website or user"},
	{"question": "What is the primary function of a VPN?", "answers": ["Protect online privacy", "Speed up internet", "Enhance browser features"], "correct_answer": "Protect online privacy"},
	{"question": "What is the purpose of a cryptographic key?", "answers": ["Encrypt and decrypt data", "Change user password", "Install software"], "correct_answer": "Encrypt and decrypt data"},
	{"question": "What is the purpose of network segmentation?", "answers": ["Limit the spread of attacks", "Increase system speed", "Reduce network latency"], "correct_answer": "Limit the spread of attacks"},
	{"question": "What does 'ransomware as a service' mean?", "answers": ["Renting ransomware tools", "Free malware protection", "Purchasing software patches"], "correct_answer": "Renting ransomware tools"},
	{"question": "Which is a common security framework?", "answers": ["NIST", "HTTPS", "SQL"], "correct_answer": "NIST"}
]

func _ready():
	randomize()

	# Connect button signals to their respective pressed functions.
	A_button.connect("pressed", Callable(self, "_on_button_pressed").bind(A_button))
	B_button.connect("pressed", Callable(self, "_on_button_pressed").bind(B_button))
	C_button.connect("pressed", Callable(self, "_on_button_pressed").bind(C_button))

	# Connect the timer signal for countdown ticking.
	timer.connect("timeout", Callable(self, "_on_timer_tick"))

	# Initialize the quiz by loading a question based on the difficulty.
	var difficulty = Global.difficulty_chosen if Global.difficulty_chosen != "" else "medium"
	print("Global difficulty chosen: ", difficulty)
	load_question(difficulty)
	update_lives_display()

	# Start the timer for the quiz.
	reset_timer()

func load_question(difficulty: String):
	print("Loading question for difficulty: ", difficulty)
	if difficulty == "easy":
		selected_question = easy_questions[randi() % easy_questions.size()]
	elif difficulty == "medium":
		selected_question = medium_questions[randi() % medium_questions.size()]
	elif difficulty == "hard":
		selected_question = hard_questions[randi() % hard_questions.size()]
	else:
		print("Error: Invalid difficulty level")
		return

	print("Selected question: ", selected_question["question"])
	if selected_question:
		result_label.text = selected_question["question"]
		var answers = selected_question["answers"].duplicate()
		answers.shuffle()

		# Set the text for RichTextLabel
		A_text.text = answers[0]
		B_text.text = answers[1]
		C_text.text = answers[2]

		# Set button metadata to store whether the answer is correct.
		A_button.set_meta("correct", answers[0] == selected_question["correct_answer"])
		B_button.set_meta("correct", answers[1] == selected_question["correct_answer"])
		C_button.set_meta("correct", answers[2] == selected_question["correct_answer"])
	else:
		print("Error: No question found!")

func check_answer(button: Button):
	# Check if the pressed button has the correct answer.
	var was_correct = button.get_meta("correct")
	if was_correct:
		result_label.text = "Correct!"
		print("Correct!")
		emit_signal("quiz_completed", was_correct)
		# Immediately transition to the main scene after button press.
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
	else:
		result_label.text = "Incorrect!"
		print("Incorrect!")
		current_lives -= 1
		update_lives_display()
		emit_signal("quiz_completed", !was_correct)
		get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_button_pressed(button: Button):
	print("Button pressed: ", button.text)
	check_answer(button)

func _on_timer_tick():
	print("Timer tick")
	# Reduce the countdown time and update the label.
	countdown_time -= 1
	countdown_label.text = str(countdown_time)

	# Change the countdown label's color when the time is low.
	if countdown_time <= 3:
		countdown_label.modulate = Color(1, 0, 0)  # Red color.
	else:
		countdown_label.modulate = Color(1, 1, 1)  # White color.

	# Handle timer expiration.
	if countdown_time <= 0:
		_on_timeout()

func _on_timeout():
	print("Timeout occurred")
	# Decrease lives if time runs out and check for game over.
	current_lives -= 1
	update_lives_display()
	if current_lives <= 0:
		game_over()
	else:
		get_tree().change_scene_to_file("res://main.tscn")

	# Immediately transition to the main scene when the timer runs out.
	get_tree().change_scene_to_file("res://main.tscn")

func reset_timer():
	print("Resetting timer")
	# Reset the timer and countdown label for a new question.
	countdown_time = 10
	timer.start(1)
	countdown_label.text = str(countdown_time)
	countdown_label.modulate = Color(1, 1, 1)

func update_lives_display():
	print("Updating lives display")
	# Remove all existing life icons from the container.
	for child in lives_container.get_children():
		child.queue_free()

	# Update the life icons.
	for i in range(max_lives):
		var life_icon = TextureRect.new()
		if i < current_lives:
			life_icon.texture = life_texture
		else:
			life_icon.texture = life_lost_texture
		lives_container.add_child(life_icon)

func game_over():
	print("Game over")
	# Emit a signal for the game over event.
	emit_signal("quiz_completed", false)
	# Optionally, load the game over screen.
	# get_tree().change_scene(game_over_screen)
