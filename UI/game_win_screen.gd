extends NinePatchRect





func _on_level_select_button_button_down():
	get_tree().change_scene_to_packed(preload("res://UI/LevelSelectScreen.tscn"))
