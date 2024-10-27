extends Node2D

var switched = false

signal button_pressed

#set animation to off
func _ready():
	$AnimatedSprite2D.set_animation("off")
	
#when the player gets close to the switch
func _on_player_detection_body_entered(_body):
	$AnimatedSprite2D.play()

#when the play leaves the area
func _on_player_detection_body_exited(_body):
	$AnimatedSprite2D.stop()

#when the player
func _unhandled_input(event:InputEvent):
	#only switch if player is within bounds
	if event.is_action_pressed("interact") and $PlayerDetection.get_overlapping_bodies().size() > 0: 
		switched = not switched
		$AnimatedSprite2D.set_animation("on" if switched else "off")
		button_pressed.emit()
		print("switch pressed")
