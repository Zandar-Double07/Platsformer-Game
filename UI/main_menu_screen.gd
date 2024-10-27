extends NinePatchRect

var settings_screen = preload("res://UI/SettingsScreen.tscn")

func _on_level_select_button_button_down():
	get_tree().change_scene_to_packed(load("res://UI/LevelSelectScreen.tscn"))


func _on_settings_button_button_down():
	add_child(settings_screen.instantiate())

func _on_exit_button_button_down():
	#Save Game
	get_tree().quit()
