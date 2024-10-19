class_name Player
extends CharacterBody2D

const SPEED = 200
const ACCELERATION = SPEED * 6
const FRICTION = SPEED * 6
const PUSH_FORCE = 80
signal died

var isAlive := true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var crush_detection = $CrushDetection

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if isAlive:
		var animation_type: String
		if not is_on_floor():
			self.velocity.y += gravity * delta
			
		#if an input was pressed
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = move_toward(velocity.x, (SPEED * direction), (ACCELERATION * delta))
		else:
			velocity.x = move_toward(velocity.x, 0, (FRICTION * delta))
		handle_movement_animation(direction)
		move_and_slide()
		apply_floor_snap()
		if crush_detection.isCrushed():
			handle_death()
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
	
func handle_movement_animation(direction):
	if direction == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")
		if(direction == -1):
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	
func handle_death():
	#play death animation
	print("aaaa")
	isAlive = false
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_looped
	print("animation finished")
	#let game know player died
	died.emit()
	queue_free()
	#temporary!
	if is_inside_tree():
		get_tree().reload_current_scene()
	
