extends AnimatableBody2D

const EXTEND_SPEED = -10000
const MINIMUM_EXTENSION = 32
enum PlatformGroup {STONE, DIRT, WOOD}
const PUSH_FORCE = 100

#easy object access
@onready var bottom_left_corner = $BottomLeftCorner
@onready var platform_collision:CollisionPolygon2D = $PlatformCollision
@onready var platform_sprite:Polygon2D = $PlatformSprite
@onready var extension_body:CharacterBody2D = $ExtensionBody
@onready var extension_collision:CollisionShape2D = $ExtensionBody/ExtensionCollision
@onready var base_collision = $BottomLeftCorner/BaseCollision


#variables used to calculate the minimum length
var extension_min_y:int

#export variables
@export var isReversed = false
@export var isDisableable = false
@export var isSpiked = false
@export var platformGroup: PlatformGroup = PlatformGroup.STONE
@export var extension_segment:SegmentShape2D = preload("res://Extending Platforms/default_extending_platform_length.tres")
@export var base_segment:SegmentShape2D = preload("res://Extending Platforms/default_extending_platform_length.tres")

#function to easily create a PackedVector2Array from the segment nodes
func _create_shape():
	var points: PackedVector2Array = PackedVector2Array()
	points.append(extension_segment.a + extension_body.position)
	points.append(extension_segment.b + extension_body.position)
	points.append(base_segment.b + bottom_left_corner.position)
	points.append(base_segment.a + bottom_left_corner.position)
	return points

	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#assign shape to Extension Body
	extension_collision.shape = extension_segment
	base_collision.shape = base_segment
	#Create polygon to assign to Collision
	var points:PackedVector2Array = _create_shape()
	$PlatformCollision.set_polygon(points)
	$PlatformSprite.set_polygon(points)
	extension_body.add_collision_exception_with(self)
	


#Handle platform movement
func _physics_process(delta):
	#variable to move by
	var direction = Input.get_axis("platform_contract", "platform_extend")
	var extension_velocity
	#if moving
	if direction:
		#set velocity
		extension_velocity = Vector2(0, EXTEND_SPEED * direction) * delta
		if(isReversed):
			extension_velocity *= -1
		extension_velocity = extension_velocity.rotated(rotation)
		extension_body.velocity = extension_velocity
		#move extension body
		extension_body.move_and_slide()
		#handle collsions with player and movable objects
		for i in extension_body.get_slide_collision_count():
			var c = extension_body.get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
			elif c.get_collider() is Player:
				c.get_collider()
		#clamp position so that the platform does not collapse on on itself
		if extension_body.position.distance_to(bottom_left_corner.position) < MINIMUM_EXTENSION:
			extension_body.set_position(Vector2(bottom_left_corner.position.x, bottom_left_corner.position.y - MINIMUM_EXTENSION))
		
		#set the new shape. Deffered call to ensure that extending platforms can collide with other extending platforms
		var new_shape: PackedVector2Array = _create_shape()
		$PlatformCollision.call_deferred("set_polygon", new_shape)
		$PlatformSprite.call_deferred("set_polygon", new_shape)
