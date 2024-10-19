extends Node2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var nine_patch_rect:NinePatchSprite2D = %NinePatchSprite2D

@export var shape_scale = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = Vector2(64 * shape_scale.x, 64 * shape_scale.y)
	var lava_rect:RectangleShape2D = collision_shape_2d.shape
	lava_rect.size = size
	collision_shape_2d.shape = lava_rect
	nine_patch_rect.size = size
	#center the nine_patch on the box
