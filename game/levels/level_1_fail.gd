extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if LevelTransition.blacked_out == true:
		await LevelTransition.fade_from_black()
		
func _on_main_menu_button_pressed():
	_end_level()

func _on_quit_game_button_pressed():
	get_tree().quit()
