extends Node2D
@onready var collision_shape_2d = $Hazard/CollisionShape2D
@onready var hazardShape:RectangleShape2D = collision_shape_2d.get_shape()

@export var num_spikes = 1

func _ready():
	var spike_size = Vector2(16 * num_spikes, 16)
	hazardShape.size = spike_size
	collision_shape_2d.shape = hazardShape
	$NinePatchSprite2D.size = spike_size
