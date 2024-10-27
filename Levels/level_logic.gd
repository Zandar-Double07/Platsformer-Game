extends Node2D
signal active_platform_group_changed


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelMenuHandler.show()
	$Player.global_position = $StartPoint.global_position
	GameState.toggle_game_paused(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#handle game pausing and un pausing
func _input(event):
	if event.is_action_pressed("pause"):
		#Only pause or unpause if player is around, 
		#which doesn't happen if player is dead or level completed
		if find_child("Player"):
			if($LevelMenuHandler/PauseScreen.is_visible()):
				GameState.toggle_game_paused(false)
				$LevelMenuHandler/PauseScreen.hide()
			else:
				$LevelMenuHandler/PauseScreen.show()
				GameState.toggle_game_paused(true)
			
#handle changing active platforms
func _unhandled_input(event):
	if(not GameState.is_paused):
		if event.is_action_pressed("swap_active_platform"):
			if ExtendingPlatform.activePlatformGroup >= ExtendingPlatform.PlatformGroup.size() - 1:
				ExtendingPlatform.activePlatformGroup = 0
			else:
				ExtendingPlatform.activePlatformGroup = ExtendingPlatform.activePlatformGroup + 1
			print("active platform group is: " + str(ExtendingPlatform.activePlatformGroup))
		
func _on_player_died():
	GameState.toggle_game_paused(true)
	$LevelMenuHandler/DeathScreenTexture.show()

#when the door is entered, the level is compelete
func _on_door_entered():
	$Player.queue_free()
	#$Interactables/Door.
	#handles level completion checking
	var current_scene_file = get_tree().current_scene.scene_file_path
	var is_special_level:bool = current_scene_file.contains("Special_Level")
	if is_special_level and current_scene_file.to_int() > GameState.special_levels_completed:
		GameState.special_levels_completed += 1
	else:
		var level_world_number:String = current_scene_file.trim_suffix(".tscn").right(3)
		var level_world := level_world_number.left(1).to_int()
		var level_number := level_world_number.right(1).to_int()
		if(level_world > GameState.level_sets_completed && level_number > GameState.levels_in_set_completed):
			GameState.levels_in_set_completed += 1
			if(GameState.levels_in_set_completed == 5):
				GameState.levels_in_set_completed = 0
				GameState.level_sets_completed += 1
	
	GameState.toggle_game_paused(true)
	$LevelMenuHandler/LevelCompleteScreen.show()
	
	
