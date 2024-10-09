extends Area2D

class_name Invader

signal invader_destroyed(invader: Invader, points: int)


var config: Resource
@onready var sprite = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Row and column properties to track invader's position in the grid
var row: int
var column: int

# Variable to hold the enemy type
var enemy_type: String  

func _ready():
	# Assign texture and start animation based on config
	sprite.texture = config.sprite_1
	animation_player.play(config.animation_name)
	
	# Set enemy_type based on the config file
	if config == preload("res://Resources/invader_3.tres"):
		enemy_type = "Trojan Virus"
	elif config == preload("res://Resources/invader_1.tres"):
		enemy_type = "Spyware"
	elif config == preload("res://Resources/invader_2.tres"):
		enemy_type = "Malware"



# Triggered when a laser or bomb hits the invader
func _on_area_entered(area):
	if area is Laser:
		# Play destruction animation, remove the laser/bomb
		animation_player.play("destroy")
		area.queue_free()

# Called when the destruction animation finishes
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroy":
		# Once destroyed, remove invader and emit the destruction signal
		emit_signal("invader_destroyed", self,  config.points)
		queue_free()

# A method to handle external invader destruction calls
func destroy():
	animation_player.play("destroy")
