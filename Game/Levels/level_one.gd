extends Node2D

@onready var object_controller := %ObjectController as ObjectController
@onready var engineer := %Engineer as Engineer
@onready var accuracy_label = %AccuracyLabel
@onready var robot_stats = %RobotStats


@export var chosen_object: Node

var object_accepted: bool
var objects_scanned_in_total: int
var objects_scanned_correctly: int
var accuracy_rate: float

var level_dialogue = "res://Game/Dialogues/level_one.dialogue"

func _ready() -> void:
	engineer.show_normal_dialogue(level_dialogue, "engineer_opening_lines")
	engineer.robot_boot.connect(_booting_up_the_robot)
	engineer.stats_introduced.connect(_accuracy_label_activated)

func _on_reject_button_pressed():
	object_accepted = false
	_making_a_choice(object_accepted)

func _on_accept_button_pressed():
	object_accepted = true
	_making_a_choice(object_accepted)

func _booting_up_the_robot():
	object_controller.show_new_object()
	print("This object's index is ", object_controller.current_object_index)
	LevelTransition.fade_from_black()
	await get_tree().create_timer(1.5).timeout
	await engineer.show_normal_dialogue(level_dialogue, "robot_booted_up")
	await engineer.engineer_coming_in()
	await engineer.show_normal_dialogue(level_dialogue, "explaining_the_mechanics")
	
func _making_a_choice(_players_choice):
	objects_scanned_in_total += 1
	if (_players_choice == object_controller.current_object_acceptable):
		print("You are correct!")
		objects_scanned_correctly += 1
	else:
		print("Wrong answer!")
	_accuracy_label_updated()
	object_controller.show_new_object()
	#_stats()

func _accuracy_label_activated():
	accuracy_label.text = "Accuracy rate: #NODATA!"
	robot_stats.visible = true
	
func _accuracy_label_updated():
	accuracy_rate = (int(round((float(objects_scanned_correctly) / objects_scanned_in_total) * 100)))
	accuracy_label.text = "Accuracy rate: %s%%" % accuracy_rate

func _stats():
	print("Objects scanned in total: ", objects_scanned_in_total)
	print("Objects scanned correctly: ", objects_scanned_correctly)
	print("This object's index is ", object_controller.current_object_index)
