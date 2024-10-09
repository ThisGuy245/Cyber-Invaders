extends Area2D
class_name Player

@export var speed = 200

signal player_destroyed

var direction = Vector2.ZERO
@onready var collision_rect: CollisionShape2D = $CollisionShape2D
@onready var animation_player = $AnimationPlayer

var bounding_size_x
var start_bound
var end_bound

func _ready():
	bounding_size_x = collision_rect.shape.get_rect().size.x / 2
	var rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	var camera_position = camera.position
	start_bound = (camera_position.x - rect.size.x) / 2
	end_bound = (camera_position.x + rect.size.x) / 2
	print("Player ready. Start bound: ", start_bound, ", End bound: ", end_bound)

func _process(delta):
	var _screen_bounding_box = get_viewport_rect().end.x
	var input = Input.get_axis("move_left", "move_right")
	if input > 0:
		direction = Vector2.RIGHT
	elif input < 0:
		direction = Vector2.LEFT
	else:
		direction = Vector2.ZERO

	var deltaMovement = speed * delta * direction.x
	if position.x + deltaMovement < start_bound + bounding_size_x * transform.get_scale().x or position.x + deltaMovement > end_bound - bounding_size_x * transform.get_scale().x:
		return
	position.x += deltaMovement

func on_player_destroyed():
	speed = 0
	animation_player.play("destroy")
	print("Player destroyed")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroy":
		await get_tree().create_timer(1).timeout
		player_destroyed.emit()
		queue_free()
		
func _on_area_entered(area):
	if area is Security:
		speed = 0
