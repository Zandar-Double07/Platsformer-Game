class_name Door
extends Area2D
signal door_entered

var unlocked:bool = false

#unlock door if no keys in level at the start
func _ready():
	$AnimatedSprite2D.frame = 0
	if get_tree().get_node_count_in_group("keys") == 0:
		set_unlocked()
	door_entered.connect((find_parent("Level") as Level)._on_door_entered)

func _input(event):
	if(event.is_action_pressed("interact") and get_overlapping_bodies().size() > 0 and unlocked): 
		door_entered.emit()
		print("door entered")

func set_unlocked():
	unlocked = true
	$AnimatedSprite2D.frame = 1
	
