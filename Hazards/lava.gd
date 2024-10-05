extends Node2D
@onready var collision_shape_2d = %CollisionShape2D
@onready var nine_patch_rect:NinePatchRect = %NinePatchRect

@export var shape_scale = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = Vector2(64 * shape_scale.x, 64 * shape_scale.y)
	var lava_rect:RectangleShape2D = collision_shape_2d.shape
	lava_rect.size = size
	collision_shape_2d.shape = lava_rect
	nine_patch_rect.size = size
	#center the nine_patch on the box
	nine_patch_rect.set_position(Vector2(-size.x / 2, -size.y / 2))
	
	
