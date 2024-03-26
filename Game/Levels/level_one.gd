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
	# DialogueManager.show_dialogue_balloon(load("res://game_intro.dialogue"), "engineer_scrumbling")

func _process(_delta):
	if (Global.robot_booted_up == true):
		_first_robot_introduction()

func _on_reject_button_pressed():
	object_accepted = false
	if object_controller.current_object_acceptable == object_accepted:
		print("You made a correct choice!")
		engineer.engineer_going_out()
	else:
		print("Wrong choice!")
	object_controller.show_new_object()
	#player_choice = PossiblePlayerChoices.REJECT

func _on_accept_button_pressed():
	object_accepted = true
	if object_controller.current_object_acceptable == object_accepted:
		print("You made a correct choice!")
	else:
		print("Wrong choice!")
	object_controller.show_new_object()
	#player_choice = PossiblePlayerChoices.ACCEPT

#func _on_object_controller_new_object_chosen():
	#chosen_object = object_controller.current_object
	#print(chosen_object.object_properties.object_defects)
	
func _first_robot_introduction():
	Global.robot_booted_up = false
	object_controller.show_new_object()
	LevelTransition.fade_from_black()
	await get_tree().create_timer(1.5).timeout
	engineer.engineer_coming_in()
	engineer.show_normal_dialogue("res://Game/Dialogues/game_introduction.dialogue", "robot_booted_up_first_time")
