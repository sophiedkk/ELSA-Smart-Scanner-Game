extends Node2D
class_name Engineer

@onready var animation_player = $AnimationPlayer

#These variables control the flow of the dialogue
var dialogue_in_progress = false
var cd_path
var cd_part

#Supplementary signals
signal robot_boot
signal stats_introduced

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)


func show_normal_dialogue(dialogue_path, dialogue_part):
	#This section defers the next (automatic) dialogue section if the current one is still in progress
	#I am NOT sure if this is the optimal way to do that
		if (dialogue_in_progress == true):
			await get_tree().create_timer(2.0).timeout
			return await show_normal_dialogue(dialogue_path, dialogue_part)
		dialogue_in_progress = true
		cd_path = dialogue_path
		cd_part = dialogue_part
		DialogueManager.show_dialogue_balloon(load(dialogue_path), dialogue_part)

#Dictates what should be done after the dialogue finished.
#NOTE: cd_part happens BEFORE this script
func _on_dialogue_finished() -> void:
	match cd_path:
		"res://Game/Dialogues/level_one.dialogue":
			match cd_part:
				"engineer_opening_lines":
					await get_tree().create_timer(2.0).timeout
					robot_boot.emit()
				"robot_booted_up":
					engineer_going_out()
					await get_tree().create_timer(1.0).timeout
					stats_introduced.emit()
	dialogue_in_progress = false

func engineer_coming_in():
	animation_player.play("engineer_coming_in")
	await animation_player.animation_finished
	
func engineer_going_out():
	animation_player.play("engineer_going_out")
	await animation_player.animation_finished
