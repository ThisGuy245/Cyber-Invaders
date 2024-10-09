extends Control

func _ready():
	populate_leaderboard()

func populate_leaderboard():
	var leaderboard_container = $VBoxContainer
	leaderboard_container.clear()
	
	for entry in Global.leaderboard:
		var entry_label = Label.new()
		entry_label.text = entry.name + ": " + str(entry.score)
		leaderboard_container.add_child(entry_label)

	# Add the current player's score
	var player_label = Label.new()
	player_label.text = Global.player_name + ": " + str(Global.player_score)
	leaderboard_container.add_child(player_label)

	# Add the player's score to the global leaderboard
	Global.add_score(Global.player_name, Global.player_score)
