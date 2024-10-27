extends NinePatchRect



func _on_resume_button_button_down():
	hide()

func _on_reset_level_button_button_down():
	get_tree().reload_current_scene()

func _on_settings_button_button_down():
	add_child(preload("res://UI/SettingsScreen.tscn").instantiate())

func _on_level_select_button_button_down():
	get_tree().change_scene_to_packed(preload("res://UI/LevelSelectScreen.tscn"))

func _on_menu_button_button_down():
	get_tree().change_scene_to_packed(preload("res://UI/MainMenuScreen.tscn"))
