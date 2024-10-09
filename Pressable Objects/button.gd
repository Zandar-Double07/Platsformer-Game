extends Area2D

signal button_pressed

#when the button is pressed
func _on_body_entered(_body):
	#only emit signal if one item on
	var num_collisions:int = get_overlapping_bodies().size()
	if num_collisions == 1:
		button_pressed.emit()
		$AnimatedSprite2D.set_frame(1)
		print("button pressed")
		

#only unpress button if no items on button
func _on_body_exited(_body):
	var num_collisions:int = get_overlapping_bodies().size()
	if num_collisions == 0:
		button_pressed.emit()
		$AnimatedSprite2D.set_frame(0)
		print("button unpressed")
