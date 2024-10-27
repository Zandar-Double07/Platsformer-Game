extends NinePatchRect

func _on_next_level_button_button_down():
	#get currently loaded level
	var current_scene_file = get_tree().current_scene.scene_file_path
	var level_world_number:String = current_scene_file.trim_suffix(".tscn").right(3)
	var level_number := level_world_number.right(1).to_int()
	var is_special_level:bool = current_scene_file.contains("Special_Level")
	# if level is special level, check if it is the last special level
	# if it is, go to game win screen
	#otherwise go to the next one
	if is_special_level:
		if(level_number == 5):
			get_tree().change_scene_to_file("res://UI/GameWinScreen.tscn")
		else:
			get_tree().change_scene_to_file("res://Levels/Special Levels/Special_Level_S-" + str(level_number) + ".tscn")
	#if it is a normal level, go to the next one based on world you are in
	else:
		var level_world := level_world_number.left(1).to_int()
		if(level_world == 3 and level_number == 5):
			get_tree().change_scene_to_file("res://UI/GameWinScreen.tscn")
		elif level_number == 5:
			get_tree().change_scene_to_file("res://Levels/Normal Levels/Level_" + str(level_world + 1) + "-1.tscn")
		else:
			get_tree().change_scene_to_file("res://Levels/Normal Levels/Level_" + str(level_world) + "-" + str(level_number + 1) + ".tscn")



func _on_reset_level_button_button_down():
	get_tree().reload_current_scene()


func _on_level_select_button_button_down():
	get_tree().change_scene_to_packed(preload("res://UI/LevelSelectScreen.tscn"))


func _on_main_menu_button_button_down():
	get_tree().change_scene_to_packed(preload("res://UI/MainMenuScreen.tscn"))
