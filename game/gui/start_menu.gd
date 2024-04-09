extends CenterContainer

## Level that gets loaded after start button is pressed
@export var next_level: PackedScene

@onready var start_game_button: Button = %StartGameButton


func _ready():
	if (LevelTransition.blacked_out == true):
		await LevelTransition.fade_from_black()
	start_game_button.grab_focus()
	
func _on_start_game_button_pressed(): 
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_packed(next_level)
 

func _on_quit_game_button_pressed():
		get_tree().quit()
