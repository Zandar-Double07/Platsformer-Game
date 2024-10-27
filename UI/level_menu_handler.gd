extends CanvasLayer

@onready var death_screen_texture = $DeathScreenTexture
@onready var level_complete_screen = $LevelCompleteScreen
@onready var pause_screen = $PauseScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	death_screen_texture.hide()
	level_complete_screen.hide()
	pause_screen.hide()
	show()
		




func _on_player_died():
	death_screen_texture.show()


func _on_pause_screen_hidden():
		GameState.toggle_game_paused(false)
