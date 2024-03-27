extends Node2D

@onready var object_controller := %ObjectController as ObjectController
@onready var engineer := %Engineer as Engineer
@export var chosen_object: Node
var object_accepted: bool
var objects_scanned_in_total: int
var objects_scanned_correctly: int
var accuracy_rate: float

#enum PossiblePlayerChoices {ACCEPT, REJECT}
#var player_choice = PossiblePlayerChoices
func _ready():
	engineer.show_normal_dialogue("res://Game/Dialogues/game_introduction.dialogue", "engineer_opening_lines")

func _process(_delta):
	if (Global.robot_booted_up == true):
		_first_robot_introduction()

func _on_reject_button_pressed():
	object_accepted = false
	_making_a_choice(object_accepted)

func _on_accept_button_pressed():
	object_accepted = true
	_making_a_choice(object_accepted)

func _first_robot_introduction():
	Global.robot_booted_up = false
	object_controller.show_new_object()
	print("This object's index is ", object_controller.current_object_index)
	LevelTransition.fade_from_black()
	await get_tree().create_timer(1.5).timeout
	engineer.engineer_coming_in()
	engineer.show_normal_dialogue("res://Game/Dialogues/game_introduction.dialogue", "robot_booted_up_first_time")
	
func _making_a_choice(_players_choice):
	objects_scanned_in_total += 1
	if (_players_choice == object_controller.current_object_acceptable):
		print("You are correct!")
		objects_scanned_correctly += 1
	else:
		print("Wrong answer!")
	object_controller.show_new_object()
	#_stats()

func _stats():
	print("Objects scanned in total: ", objects_scanned_in_total)
	print("Objects scanned correctly: ", objects_scanned_correctly)
	print("This object's index is ", object_controller.current_object_index)
