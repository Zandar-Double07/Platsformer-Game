class_name LevelSelectButton
extends Button

var level_path:String

func _on_button_down():
	get_tree().change_scene_to_file(level_path)

func initialize(level:String, text:String, isLocked:bool):
	self.level_path = level
	self.text = text
	disabled = isLocked
	if(disabled):
		set_modulate(Color(0.5, 0.5, 0.5))
	
