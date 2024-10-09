class_name Player
extends CharacterBody2D

const SPEED = 200
const ACCELERATION = SPEED * 6
const FRICTION = SPEED * 6
const PUSH_FORCE = 80
signal died

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var crush_detection = $CrushDetection

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var animation_type: String
	if not is_on_floor():
		self.velocity.y += gravity * delta
		
	#if an input was pressed
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, (SPEED * direction), (ACCELERATION * delta))
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * delta))
		
	move_and_slide()
	apply_floor_snap()
		
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
	#handle being crushed
	if(crush_detection.isCrushed()):
		handle_death()
	

func _on_hitbox_hit():
	handle_death()
	
func handle_death():
	#play death animation
	print("aaaa")
	#let game know player died
	died.emit()
	
