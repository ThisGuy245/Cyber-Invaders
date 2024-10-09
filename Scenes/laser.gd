extends Area2D

class_name Laser

@export var speed = 300
@onready var collision_rect: CollisionShape2D = $CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	position.y -= delta * speed

