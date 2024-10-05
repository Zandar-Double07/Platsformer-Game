extends Node2D

var switched = false

signal button_pressed

#set animation to off
func _ready():
	$AnimatedSprite2D.set_animation("off")
	
#when the player gets close to the switch
func _on_player_detection_body_entered(body):
	$AnimatedSprite2D.play()

#when the play leaves the area
func _on_player_detection_body_exited(body):
	$AnimatedSprite2D.stop()

#when the player
func _unhandled_input(event:InputEvent):
	#Only switch if player is within bounds
	if event.is_action_pressed("switch") and $PlayerDetection.get_overlapping_bodies().size() > 0: 
		switched = not switched
		$AnimatedSprite2D.set_animation("off" if switched else "on")
		emit_signal("button_pressed")
		print("switch pressed")
