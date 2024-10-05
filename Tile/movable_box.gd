extends RigidBody2D


func _on_hitbox_hit():
	#play destroy sound
	queue_free()
