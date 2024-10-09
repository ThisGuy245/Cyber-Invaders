extends CanvasLayer

var life_texture = preload("res://Assets/Player/Player.png")

@onready var lifes_ui_container: HBoxContainer = $"/root/main/UI/MarginContainer/HBoxContainer"
@onready var invader_spawner: InvaderSpawner = $"/root/main/InvaderSpawner"
@onready var life_manager: LifeManager = $"/root/main/LifeManager"
@onready var points_counter: PointsCounter = $"/root/main/PointsCounter"
@onready var points_label: Label = $"/root/main/UI/MarginContainer/Points"
@onready var name_label: Label = $Name

# Preload the scene as a PackedScene
var education_scene = preload("res://input2.tscn")
var game_over_screen = preload("res://game_over.tscn")  # Placeholder for the instanced scene

signal lives_updated(new_lives_count: int)

func _ready():
	var global_node = get_tree().root.get_node("Global")
	name_label.text = "Name: " + global_node.player_name
	
	invader_spawner.game_lost.connect(on_game_lost)
	life_manager.on_life_lost.connect(on_life_lost)
	points_counter.on_points_increased.connect(Callable(self, "_on_points_increased"))

	# Utilisation de la variable globale pour initialiser les vies
	var lifes_count = Global.Lives
	for i in range(lifes_count):
		var life_texture_rect = TextureRect.new()
		life_texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		life_texture_rect.custom_minimum_size = Vector2(40, 25)
		life_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		life_texture_rect.texture = life_texture
		lifes_ui_container.add_child(life_texture_rect)

	# Émission du signal pour mettre à jour les vies dans le script d'éducation
	emit_signal("lives_updated", lifes_count)

func on_game_lost():
	print("GAME OVER")
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func on_life_lost(lifes_left: int):
	if lifes_left <= 0:
		on_game_lost()
	else:
		var life_texture_rect: TextureRect = lifes_ui_container.get_child(lifes_left)
		life_texture_rect.queue_free()

		# Mise à jour de la variable globale des vies
		Global.Lives = lifes_left

		# Émission du signal pour mettre à jour les vies dans le script d'éducation
		emit_signal("lives_updated", Global.Lives)

func _on_points_increased(points: int):
	print("Points increased:", points)
	points_label.text = "SCORE: " + str(points)
