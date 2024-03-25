extends Node2D
class_name Engineer

@onready var animation_player = $AnimationPlayer

func show_normal_dialogue(dialogue_path, dialogue_part):
	DialogueManager.show_dialogue_balloon(load(dialogue_path), dialogue_part)

func engineer_coming_in():
	animation_player.play("engineer_coming_in")
	await animation_player.animation_finished
	
func engineer_going_out():
	animation_player.play("engineer_going_out")
	await animation_player.animation_finished
