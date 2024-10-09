extends Area2D

class_name Bomb

@export var speed = 200
@export var stop_y_position = 449  # Y position at which the bomb stops

signal bomb_exploded

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

# Load bomb images for flickering stages
@onready var bomb_images = [
	preload("res://Assets/Weapons/B4.png"),
	preload("res://Assets/Weapons/B3.png"),
	preload("res://Assets/Weapons/B2.png")
]

# Explosion frames
@onready var explosion_images = [
	preload("res://Assets/Weapons/XP1.png"),
	preload("res://Assets/Weapons/XP2.png"),
	preload("res://Assets/Weapons/XP3.png")
]

# Explosion animation data
var explosion_timer: Timer
var current_explosion_frame = 0
var is_exploding = false
var explosion_sequence = [0, 1, 2, 1, 0]  # Sequence of explosion frames

# Track bomb state
var flicker_index = 0
var is_flickering = false
var flicker_timer: Timer

func _ready():
	sprite.texture = preload("res://Assets/Weapons/Bomb.png")  # Initial bomb texture
	set_process(true)

	# Set up the flicker timer
	flicker_timer = Timer.new()
	flicker_timer.wait_time = 0.5  # Time between flickers
	flicker_timer.one_shot = false
	add_child(flicker_timer)
	flicker_timer.connect("timeout", Callable(self, "_on_flicker_timeout"))

	# Set up the explosion timer
	explosion_timer = Timer.new()
	explosion_timer.wait_time = 0.2  # Time between explosion frames
	explosion_timer.one_shot = false
	add_child(explosion_timer)
	explosion_timer.connect("timeout", Callable(self, "_on_explosion_timeout"))

func _process(delta):
	# Move the bomb downwards.
	if position.y < stop_y_position:
		position.y += speed * delta
	else:
		if not is_flickering and not is_exploding:
			start_flicker()

func start_flicker():
	is_flickering = true
	speed = 0  # Stop moving the bomb
	flicker_timer.start()  # Begin the flickering phase

func _on_flicker_timeout():
	# Cycle through bomb flicker images
	sprite.texture = bomb_images[flicker_index]
	flicker_index = (flicker_index + 1) % bomb_images.size()

	# After 3 flickers, start the explosion
	if flicker_index == 0:
		flicker_timer.stop()
		start_explosion()

func start_explosion():
	is_exploding = true
	explosion_timer.start()

func _on_explosion_timeout():
	# Handle explosion animation sequence
	if current_explosion_frame < explosion_sequence.size():
		sprite.texture = explosion_images[explosion_sequence[current_explosion_frame]]
		current_explosion_frame += 1
	else:
		explode()  # Once the sequence is over, explode

func explode():
	emit_signal("bomb_exploded")  # Signal that the bomb exploded
	queue_free()  # Remove bomb from the scene

func _on_area_entered(area):
	if area is Player:
		start_explosion()
	elif area is Laser:
		start_explosion()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()  # Remove bomb if it exits the screen
