extends Node2D

var isDisabled := false
@onready var ray_cast_2d = $RayCast2D
@onready var collision_shape_2d = $Hazard/CollisionShape2D
@onready var nine_patch_sprite_2d = $Hazard/NinePatchSprite2D
@onready var hazard = $Hazard

func invert_disabled():
	isDisabled = not isDisabled
	if isDisabled:
		modulate = Color(0.5, 0.5, 0.5)
	else:
		modulate = Color(1,1,1)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	#determine how long the lazer should be
	var lazer_length
	if(isDisabled):
		lazer_length = 0
	elif (ray_cast_2d.is_colliding()):
		lazer_length = ray_cast_2d.global_position.distance_to(ray_cast_2d.get_collision_point(0))
	else:
		lazer_length = abs(ray_cast_2d.target_position.y)
	#set lazer size
	var lazer_shape:RectangleShape2D = RectangleShape2D.new()
	lazer_shape.size = Vector2(float(nine_patch_sprite_2d.size.x), (lazer_length))
	nine_patch_sprite_2d.size = lazer_shape.size
	collision_shape_2d.call_deferred("set_shape", lazer_shape)
	#center lazer position
	hazard.position = Vector2(hazard.position.x, -(lazer_length + 24) / 2 )
	
	
