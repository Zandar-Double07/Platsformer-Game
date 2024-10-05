extends Node2D

func _ready():
	$AnimatedSprite2D.play("default")


func _on_hitbox_hit():
	queue_free() # Replace with function body.
