extends Level

@onready var start_game_button: Button = %StartGameButton

func _ready():
	super._ready()
	if LevelTransition.blacked_out == true:
		await LevelTransition.fade_from_black()
	start_game_button.grab_focus()


func _on_start_game_button_pressed():
	_end_level()


func _on_quit_game_button_pressed():
	get_tree().quit()


func _on_switch_language_pressed():
	if Global.current_locale == "nl":
		Global.current_locale = "en"
	elif Global.current_locale == "en":
		Global.current_locale = "nl"
	TranslationServer.set_locale(Global.current_locale)
