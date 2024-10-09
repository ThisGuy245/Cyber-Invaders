extends Area2D

signal invader_destroyed(points: int)

@export var speed: float = 200
@export var projectile_scene: PackedScene
@export var points: int = 160  # Points awarded for destroying the UFO (100 + 60)
@onready var shooting_point: Node2D = $ShootingPoint
@onready var attack_timer: Timer = $AttackTimer
@onready var shooting_timer: Timer = $ShootingTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var moving_right: bool = true
var attack_type: int
var shots_fired: int = 0
var total_shots: int = 0
var config: Resource 

func _ready():
	Global.connect("pause_game", Callable(self, "_on_pause_game"))
	Global.connect("resume_game", Callable(self, "_on_resume_game"))
	moving_right = position.x < get_viewport().size.x / 2

	attack_timer.wait_time = randf_range(8, 15)
	attack_timer.connect("timeout", Callable(self, "_on_AttackTimer_timeout"))
	attack_timer.start()

	shooting_timer.connect("timeout", Callable(self, "_on_ShootingTimer_timeout"))

	#connect("area_entered", Callable(self, "_on_area_entered"))
	animation_player.connect("animation_finished", Callable(self, "_on_animation_player_animation_finished"))

func _process(delta):
	if Global.is_paused:
		return

	if moving_right:
		position.x += speed * delta
		if position.x >= get_viewport().size.x / 2:
			moving_right = false
	else:
		position.x -= speed * delta
		if position.x <= -575:
			moving_right = true

func _on_AttackTimer_timeout():
	if Global.is_paused:
		return

	randomize()
	attack_type = randi() % 2
	if attack_type == 0:
		_shoot_once()
	else:
		shots_fired = 0
		total_shots = 3 * 4
		shooting_timer.start(0.5)

	attack_timer.wait_time = randf_range(8, 15)
	attack_timer.start()

func _on_ShootingTimer_timeout():
	if Global.is_paused:
		return

	if shots_fired < total_shots:
		var projectile = projectile_scene.instantiate()
		if projectile:
			projectile.global_position = shooting_point.global_position + Vector2((shots_fired % 4) * 10, 0)
			get_tree().root.add_child(projectile)
		shots_fired += 1
	else:
		shooting_timer.stop()

func _shoot_once():
	if Global.is_paused:
		return

	var projectile = projectile_scene.instantiate()
	if projectile:
		projectile.global_position = shooting_point.global_position
		get_tree().root.add_child(projectile)

func _on_pause_game():
	print("Destroyed")
	queue_free()  # Remove the UFO when the game is paused

func _on_resume_game():
	print("Resuming game")
	queue_free()  # Ensure the current UFO is removed
	emit_signal("invader_destroyed", points)  # Emit signal to handle any necessary cleanup

func _on_area_entered(area):
	if area is Laser:
		print("Destroyed")
		area.queue_free()
		animation_player.play("destroy")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroy":
		queue_free()
		emit_signal("invader_destroyed", points)
