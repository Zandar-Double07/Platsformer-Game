extends NinePatchRect


func _ready():
	show()

#settings is only brought up from another screen
#so it is hidden after pressing the back button
func _on_back_button_button_down():
	queue_free()
