extends Node


#game settings
var fast_transitions = false



#in-game state

var level_sets_completed := 0
var levels_in_set_completed := 0
var special_levels_completed := 0
var is_paused := false

func toggle_game_paused(isPaused:bool):
	if(is_inside_tree()):
		get_tree().set_pause(isPaused)
		is_paused = isPaused
