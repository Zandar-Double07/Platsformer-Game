extends AnimatableBody2D

enum PlatformGroup {STONE, DIRT, WOOD}

const EXTEND_SPEED = -100
const MINIMUM_EXTENSION = 32
const PUSH_FORCE = 100

#export variables
@export var isReversed = false
@export var isDisableable = false
#object that sticks to the platform's top
@export var platformChild:Node2D
@export var thisPlatformGroup: PlatformGroup = PlatformGroup.STONE
#shapes to determine the shape and length of the platform
@export var extension_segment:SegmentShape2D = preload("res://Extending Platforms/default_extending_platform_length.tres")
@export var base_segment:SegmentShape2D = preload("res://Extending Platforms/default_extending_platform_length.tres")

static var activePlatformGroup:PlatformGroup = PlatformGroup.STONE:
	get:
		return activePlatformGroup
	set(newActiveGroup):
		activePlatformGroup = newActiveGroup


#easy object access
@onready var bottom_left_corner = $BottomLeftCorner
@onready var platform_collision:CollisionPolygon2D = $PlatformCollision
@onready var platform_sprite:Polygon2D = $PlatformSprite
@onready var extension_body:CharacterBody2D = $ExtensionBody
@onready var extension_collision:CollisionShape2D = $ExtensionBody/ExtensionCollision


# Called when the node enters the scene tree for the first time.
func _ready():
	#set platform sprite based on given group
	match thisPlatformGroup:
		PlatformGroup.STONE:
			platform_sprite.texture = load("res://Extending Platforms/stone-platform.png")
		PlatformGroup.DIRT:
			platform_sprite.texture = load("res://Extending Platforms/dirt-platform.png")
		PlatformGroup.WOOD:
			platform_sprite.texture = load("res://Extending Platforms/wood-platform.png")
	#assign platform child to extension body and center it
	if platformChild:
		call_deferred("assign_platform_child")
		
	#assign shape to Extension Body and center it
	extension_collision.shape = extension_segment
	#Create polygon to assign to Collision
	var points:PackedVector2Array = create_shape()
	$PlatformCollision.set_polygon(points)
	$PlatformSprite.set_polygon(points)
	extension_body.add_collision_exception_with(self)


#process platform
func _physics_process(_delta):
		var direction = Input.get_axis("platform_contract", "platform_extend")
		#move the platform
		if thisPlatformGroup == activePlatformGroup:
			extend_platform(direction)
			#set the new shape. Deffered call to ensure that extending platforms can collide with other extending platforms
			var new_shape: PackedVector2Array = create_shape()
			$PlatformCollision.call_deferred("set_polygon", new_shape)
			$PlatformSprite.call_deferred("set_polygon", new_shape)


#function to easily create a PackedVector2Array from the segment nodes
func create_shape():
	var points: PackedVector2Array = PackedVector2Array()
	points.append(extension_segment.a + extension_body.position + Vector2.DOWN)
	points.append(extension_segment.b + extension_body.position + Vector2.DOWN)
	points.append(base_segment.b + bottom_left_corner.position)
	points.append(base_segment.a + bottom_left_corner.position)
	return points

#function to set the platform child to the extending platform
func assign_platform_child():
	if platformChild.get_parent():
		platformChild.reparent(extension_body, true)
	else:
		extension_body.add_child(platformChild)
	var extension_midpoint = Vector2(extension_segment.a.distance_to(extension_segment.b) / 2, -8)
	platformChild.position = extension_midpoint
	platformChild.rotation = platformChild.get_parent().rotation

#function for handling platform extension and contraction
func extend_platform(direction:float):
	var extension_velocity:Vector2
	#if moving
	if direction:
		#set velocity
		extension_velocity = Vector2(0, EXTEND_SPEED * direction)
		if(isReversed):
			extension_velocity *= -1
		extension_velocity = extension_velocity.rotated(rotation)
		extension_body.velocity = extension_velocity
		#move extension body
		extension_body.move_and_slide()
		#handle collsions with player and movable objects
		for i in extension_body.get_slide_collision_count():
			var c = extension_body.get_slide_collision(i)
			var collidor = c.get_collider()
			if collidor is RigidBody2D:
				collidor.apply_central_impulse(-c.get_normal() * PUSH_FORCE)
			elif collidor is Player:
				collidor.velocity = PUSH_FORCE * -c.get_normal()
		#clamp position so that the platform does not collapse on on itself
		if extension_body.position.distance_to(bottom_left_corner.position) < MINIMUM_EXTENSION:
			extension_body.set_position(Vector2(bottom_left_corner.position.x, bottom_left_corner.position.y - MINIMUM_EXTENSION))
