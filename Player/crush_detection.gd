class_name CrushDetection
extends Node2D

@onready var crush_left = $CrushLeft
@onready var crush_right = $CrushRight
@onready var crush_up = $CrushUp
@onready var crush_down = $CrushDown

func isCrushed() -> bool:
	return crush_left.is_colliding() and crush_right.is_colliding() \
		or crush_down.is_colliding() and crush_up.is_colliding()
		
	
	
