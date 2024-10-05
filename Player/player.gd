class_name Player
extends CharacterBody2D

const SPEED = 200
const ACCELERATION = SPEED * 6
const FRICTION = SPEED * 6
const PUSH_FORCE = 80
signal died

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var animation_type: String
	if not is_on_floor():
		self.velocity.y +=  gravity * delta
		
	#if an input was pressed
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, (SPEED * direction), (ACCELERATION * delta))
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * delta))
	
	#handle pushing boxes
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
	

func _on_hitbox_hit():
	#play death animation
	print("aaaa")
	#let game know player died
	emit_signal("died")
