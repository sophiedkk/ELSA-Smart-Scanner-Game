class_name Engineer
extends Node2D

#Level 1 signal
signal robot_boot
signal accept_introduced
signal reject_introduced
signal stats_introduced
signal level_restart

#Level 2 signal
signal tree_created
signal deck_introduced
signal new_tree_construction

#Level 3 signal
signal initial_patient_dialogue
signal spawn_the_pills
signal restore_UI
signal show_result_menu(correct_result: bool)
signal call_the_engineer

#Universal signal
signal level_finished

#These variables control the flow of the dialogue
var dialogue_in_progress := false
var cd_path: DialogueResource
var cd_part: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var current_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)

func show_normal_dialogue(dialogue_resource: DialogueResource, dialogue_part: String):
	if dialogue_in_progress == true:
		await get_tree().create_timer(2.0).timeout
		return await show_normal_dialogue(dialogue_resource, dialogue_part)
	dialogue_in_progress = true
	cd_path = dialogue_resource
	cd_part = dialogue_part
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_part)

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
				"tree_filled_correctly_first_time", "tree_filled_correctly":
					new_tree_construction.emit()
				"all_trees_finished":
					level_finished.emit()
		"res://game/dialogue/level_three.dialogue":
			match cd_part:
				"doctor_opening_lines":
					engineer_going_out()
					await LevelTransition.fade_to_black()
					initial_patient_dialogue.emit()
				"hans_de_vries_intro", "karin_smits_intro":
					await LevelTransition.fade_from_black()
					spawn_the_pills.emit()
				"hans_de_vries_choice_1", "hans_de_vries_choice_2", "hans_de_vries_choice_4", "karin_smits_choice_1", "karin_smits_choice_2", "karin_smits_choice_4":
					show_result_menu.emit(false)
				"hans_de_vries_choice_3", "karin_smits_choice_3":
					show_result_menu.emit(true)
				"doctor_closing_lines":
					engineer_going_out()
					call_the_engineer.emit()
				"engineer_closing_lines":
					level_finished.emit()
	dialogue_in_progress = false

func engineer_coming_in():
	animation_player.play("engineer_coming_in")
	await animation_player.animation_finished

func engineer_going_out():
	animation_player.play("engineer_going_out")
	await animation_player.animation_finished
