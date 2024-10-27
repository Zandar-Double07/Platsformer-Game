class_name ExtendingPlatform 
extends AnimatableBody2D

enum PlatformGroup {STONE, DIRT, WOOD}

const EXTEND_SPEED = -200
const MINIMUM_EXTENSION = 32
const PUSH_FORCE = 200
const PLAYER_PUSH_FORCE = 100

#export variables
@export var isReversed = false
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
var extensionMidPoint:float;
var isDisabled := false

func invert_disabled():
	isDisabled = not isDisabled
	if(isDisabled):
		platform_sprite.modulate = Color(0.5, 0.5 , 0.5)
	else:
		platform_sprite.modulate = Color(1, 1, 1)
			

#easy object access
@onready var bottom_left_corner = $BottomLeftCorner
@onready var platform_collision:CollisionPolygon2D = $PlatformCollision
@onready var platform_sprite:Polygon2D = $PlatformSprite
@onready var extension_body:CharacterBody2D = $ExtensionBody
@onready var extension_collision:CollisionShape2D = $ExtensionBody/ExtensionCollision


# Called when the node enters the scene tree for the first time.
func _ready():
	#get the texture based on group
	var platform_texture
	match thisPlatformGroup:
		PlatformGroup.STONE:
			platform_texture = preload("res://Extending Platforms/platform-type-1.tres")
		PlatformGroup.DIRT:
			platform_texture = preload("res://Extending Platforms/platform-type-2.tres")
		PlatformGroup.WOOD:
			platform_texture = preload("res://Extending Platforms/platform-type-3.tres")
	#assign the atlas as the platform texture because these are all atlas textures
	platform_sprite.texture = platform_texture.atlas
	#assign platform child based
	if platformChild != null:
		call_deferred("assign_platform_child")
	#use the texture region to set the uv of the sprite
	var texture_region = (platform_texture as AtlasTexture).region
	var sprite_uv := PackedVector2Array()
	sprite_uv.append(texture_region.position)
	sprite_uv.append(texture_region.position + Vector2(texture_region.size.x, 0))
	sprite_uv.append(texture_region.end)
	sprite_uv.append(texture_region.position + Vector2(0, texture_region.size.y))
	platform_sprite.set_uv(sprite_uv)
	
	#assign shape to Extension Body and center it
	extension_collision.shape = extension_segment
	#Create polygon to assign to Collision
	var points:PackedVector2Array = create_shape()
	$PlatformCollision.set_polygon(points)
	platform_sprite.set_polygon(points)
	
	extension_body.add_collision_exception_with(self)
	extensionMidPoint = extension_segment.a.distance_to(extension_segment.b) / 2


#process platform
func _physics_process(delta):
		var direction = Input.get_axis("platform_contract", "platform_extend")
		#move the platform
		if thisPlatformGroup == activePlatformGroup and not isDisabled:
			extend_platform(direction, delta)
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
	#find platform child collision to determine the y offset of the node
	var platformCollision = platformChild.find_child("CollisionShape2D")
	var platformChildYOffset = -platformCollision.shape.get_rect().size.y / 2
	#center the child on the platform extension
	platformChild.position = Vector2(extensionMidPoint, platformChildYOffset)
	platformChild.reparent(extension_body)
	extension_body.add_collision_exception_with(platformChild)

#function for handling platform extension and contraction
func extend_platform(direction:float, delta:float):
	var extension_velocity:Vector2
	#if moving
	if direction:
		#set velocity
		extension_velocity = Vector2(0, EXTEND_SPEED * direction)
		if(isReversed):
			extension_velocity *= -1
		extension_velocity = extension_velocity.rotated(rotation)
		#test move extension body
		var collision = extension_body.move_and_collide(extension_velocity * delta)
		if (collision):
			var collidor = collision.get_collider()
			if collidor is RigidBody2D:
				collidor.apply_central_impulse(-collision.get_normal() * PUSH_FORCE)
				
			elif collidor is Player:
				collidor.velocity += PLAYER_PUSH_FORCE * -collision.get_normal()
		#clamp position so that the platform does not collapse on on itself
		if extension_body.position.distance_to(bottom_left_corner.position) < MINIMUM_EXTENSION:
			extension_body.set_position(Vector2(bottom_left_corner.position.x, bottom_left_corner.position.y - MINIMUM_EXTENSION))
