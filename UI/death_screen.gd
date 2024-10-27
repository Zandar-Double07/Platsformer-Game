extends NinePatchRect


func _on_retry_button_button_down():
	get_tree().reload_current_scene()
	
func _on_level_select_button_down():
	get_tree().change_scene_to_packed(preload("res://UI/LevelSelectScreen.tscn"))

func _on_menu_select_button_button_down():
	get_tree().change_scene_to_packed(preload("res://UI/MainMenuScreen.tscn"))
