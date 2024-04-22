class_name Engineer
extends Node2D

#Level 1 Signals
signal robot_boot
signal accept_introduced
signal reject_introduced
signal stats_introduced
signal level_finished
signal level_restart

#Level 2 Signals
signal tree_created
signal deck_introduced
signal new_tree_construction

#These variables control the flow of the dialogue
var dialogue_in_progress := false
var cd_path: DialogueResource
var cd_part: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)
	
func show_normal_dialogue(dialogue_resource: DialogueResource, dialogue_part: String):
	#This section defers the next (automatic) dialogue section if the current one is still in progress
	#I am NOT sure if this is the optimal way to do that
	if dialogue_in_progress == true:
		await get_tree().create_timer(2.0).timeout
		return await show_normal_dialogue(dialogue_resource, dialogue_part)
	dialogue_in_progress = true
	cd_path = dialogue_resource
	cd_part = dialogue_part
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_part)
	
#Dictates what should be done after the dialogue finished.
func _on_dialogue_finished() -> void:
	match cd_path.resource_path:
		"res://game/dialogue/level_one.dialogue":
			match cd_part:
				"engineer_opening_lines":
					await get_tree().create_timer(2.0).timeout
					robot_boot.emit()
				"explaining_the_mechanics":
					# engineer_going_out()
					await get_tree().create_timer(0.5).timeout
					accept_introduced.emit()
				"tutorial_nice_apple_accepted":
					await get_tree().create_timer(0.5).timeout
					reject_introduced.emit()
				"tutorial_bad_apple_rejected":
					engineer_going_out()
					await get_tree().create_timer(1.5).timeout
					stats_introduced.emit()
				"all_objects_analyzed_correctly":
					level_finished.emit()
				"all_objects_analyzed_incorrectly":
					level_restart.emit()
		"res://game/dialogue/level_two.dialogue":
			match cd_part:
				"rensselaer_opening_lines":
					engineer_going_out()
					tree_created.emit()
				"introduction_to_decision_trees":
					deck_introduced.emit()
				"tree_filled_correctly_first_time":
					new_tree_construction.emit()
				"tree_filled_correctly":
					new_tree_construction.emit()
				"all_trees_finished":
					level_finished.emit()
	dialogue_in_progress = false

func engineer_coming_in():
	animation_player.play("engineer_coming_in")
	await animation_player.animation_finished

func engineer_going_out():
	animation_player.play("engineer_going_out")
	await animation_player.animation_finished
