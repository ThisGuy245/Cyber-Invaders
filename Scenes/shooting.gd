extends Node2D

@export var laser_scene: PackedScene

@onready var shoot_timer: Timer = $ShootTimer

func _ready():
	shoot_timer.one_shot = true
	shoot_timer.wait_time = 0.3

func _input(event):
	if Input.is_action_just_pressed("shoot"):
		if shoot_timer.is_stopped():
			shoot()
		else:
			pass

func shoot():
	var laser = laser_scene.instantiate() as Area2D
	if laser:
		laser.global_position = global_position - Vector2(0, 20)
		get_tree().root.get_node("main").add_child(laser)
		laser.tree_exited.connect(on_laser_destroyed)
		shoot_timer.start()
	else:
		pass

func on_laser_destroyed():
	pass
