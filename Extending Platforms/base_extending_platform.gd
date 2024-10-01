extends AnimatableBody2D

const EXTEND_SPEED = -100

#easy object access
@onready var top_right_corner = $TopRightCorner
@onready var bottom_left_corner = $BottomLeftCorner
@onready var bottom_right_corner = $BottomRightCorner
@onready var top_left_corner = $TopLeftCorner
@onready var platform_collision = $PlatformCollision
@onready var platform_sprite = $PlatformSprite

#variables used to remember where the shape started
var tl_corner_start:Vector2
var tr_corner_start:Vector2
var collision_detector:ShapeCast2D

#type variables
@export var isReversed = false
@export var isDisableable = false


#function to easily create a PackedVector2Array from the corner nodes
func _create_polygon_from_corners():
	var points: PackedVector2Array = PackedVector2Array()
	points.append(top_left_corner.position)
	points.append(top_right_corner.position)
	points.append(bottom_right_corner.position)
	points.append(bottom_left_corner.position)
	return points
	
func _create_shape_cast():
	var shape_cast = ShapeCast2D.new()
	var distance = tl_corner_start.distance_to(tr_corner_start)
	var cast_rect = RectangleShape2D.new()
	cast_rect.set_size(Vector2(distance, 2))
	var platform_mid_point = Vector2((top_left_corner.position.x + top_right_corner.position.x) / 2, (top_left_corner.position.y + top_right_corner.position.y)/2 + 1)
	shape_cast.set_shape(cast_rect)
	shape_cast.position = platform_mid_point
	shape_cast.set_target_position(Vector2(0, EXTEND_SPEED * get_process_delta_time()))
	shape_cast.add_exception(self)
	shape_cast.set_collision_mask_value(1, false)
	var collision_mask_values:Array = [2, 3]
	for value:int in collision_mask_values:
		shape_cast.set_collision_mask_value(value, true)
	return shape_cast
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#Create polygon to assign to Collision
	var points:PackedVector2Array = _create_polygon_from_corners()
	$PlatformCollision.set_polygon(points)
	$PlatformSprite.set_polygon(points)
	#assign corner start positions
	tl_corner_start = top_left_corner.position
	tr_corner_start = top_right_corner.position
	#set up shape cast
	collision_detector = _create_shape_cast()
	top_left_corner.add_child(collision_detector)

	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#variable to move by
	var direction = Input.get_axis("platform_contract", "platform_extend")
	var move_point
	#if moving
	if direction:
		#Create move point
		move_point = Vector2(0, EXTEND_SPEED * direction) * delta
		if(isReversed):
			move_point *= -1
		#update collision_detector
		collision_detector.set_target_position(Vector2(0, EXTEND_SPEED) * delta)
		collision_detector.force_shapecast_update()
		#check if about to colide with an object
		if(collision_detector.is_colliding()):
			#check if movement will keep it colliding
			#case for when this collides with another platform, then needs to move back
			top_left_corner.translate(move_point * 2)
			collision_detector.force_shapecast_update()
			var actually_colliding = collision_detector.is_colliding()
			top_left_corner.translate(-move_point * 2)
			#if still colliding, stop movement
			if(actually_colliding):
				move_point = Vector2.ZERO
		else:
			#check if it is about to collide
			var safe_move = roundf(collision_detector.get_closest_collision_safe_fraction())
			move_point *= safe_move
			
		#move corners
		print(move_point)
		top_left_corner.translate(move_point)
		top_right_corner.translate(move_point)
		#clamp corners so that the platform does not collapse on on itself
		if(top_left_corner.position.y > tl_corner_start.y):
			top_left_corner.position = tl_corner_start
			top_right_corner.position = tr_corner_start
		
		#set the new shape. Deffered call to ensure that extending platforms can collide with other extending platforms
		var new_shape: PackedVector2Array = _create_polygon_from_corners()
		$PlatformCollision.call_deferred("set_polygon", new_shape)
		$PlatformSprite.call_deferred("set_polygon", new_shape)
