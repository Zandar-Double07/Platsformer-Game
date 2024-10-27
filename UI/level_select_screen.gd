extends NinePatchRect
const LEVEL_BUTTON = preload("res://UI/LevelSelectButton.tscn")

@export_dir var levels_path
@export_dir var special_levels_path

@onready var grid_container = $GridContainer

func _ready():
	get_levels(levels_path)
	get_levels(special_levels_path)
func _on_main_menu_button_button_down():
	get_tree().change_scene_to_packed(load("res://UI/MainMenuScreen.tscn"))

func get_levels(path):
	#get levels in level path
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			print(file_name)
			#all levels will be in the format [Special_]Level_#-#
			var level_world_number:String = file_name.trim_prefix("Special_").trim_prefix("Level_").trim_suffix(".tscn")
			var level_number := level_world_number.right(1).to_int()
			var is_locked
			if level_world_number.contains("S"):
				is_locked = level_number > GameState.special_levels_completed + 1 or GameState.level_sets_completed < 3
			else:
				#determining if level is locked or not
				var level_world := level_world_number.left(1).to_int()
				if (level_world > GameState.level_sets_completed + 1):
					is_locked = true
				elif (level_world == GameState.level_sets_completed + 1 and level_number > GameState.levels_in_set_completed + 1):
					is_locked = true
				else:
					is_locked = false
			create_level_button('%s/%s' % [dir.get_current_dir(), file_name], file_name, is_locked)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("an error occured while trying to create the level buttons")

func create_level_button(level_path:String, level_name:String, is_locked:bool):
	var button:LevelSelectButton = LEVEL_BUTTON.instantiate()
	button.initialize(level_path, level_name.trim_prefix("Special_").trim_prefix("Level_").trim_suffix(".tscn"), is_locked)
	grid_container.add_child(button)
