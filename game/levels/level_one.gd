extends Node2D

@export var next_level: PackedScene

var object_accepted: bool
var objects_scanned_in_total: int
var objects_scanned_correctly: int
var accuracy_rate: float
var accuracy_warning_triggered: bool

@onready var object_controller: ObjectController = %ObjectController
@onready var engineer: Engineer = %Engineer

@onready var central_point = %CentralPoint
@onready var end_point = %EndPoint
var chosen_point: Node2D
var mid_point_reached: bool

@onready var reject_button = %RejectButton
@onready var accept_button = %AcceptButton

@onready var accuracy_label: RichTextLabel = %AccuracyLabel
@onready var object_type_label: Label = %ObjectTypeLabel
@onready var robot_stats: VBoxContainer = %RobotStats

@export var level_dialogue: DialogueResource

func _ready() -> void:
	_establishing_signal_connections()
	
func _process(_delta):
	if chosen_point == central_point:
		mid_point_reached = true
	else:
		mid_point_reached = false
	object_controller.move_current_object(_delta, chosen_point, 80, mid_point_reached)
	if Input.is_action_just_released("skip_level"):
		_end_the_level()
	
#Game logic	
func _establishing_signal_connections():
	
	engineer.robot_boot.connect(_booting_up_the_robot)
	engineer.accept_introduced.connect(_accept_button_activated.bind(true))
	#engineer.reject_introduced.connect(_reject_button_activated.bind(true))
	engineer.stats_introduced.connect(_stats_activated.bind(true))
	
	engineer.level_finished.connect(_end_the_level)
	engineer.level_restart.connect(_level_restart)
	
	object_controller.all_objects_passed.connect(_object_analysis_finished)
	
	chosen_point = central_point
	engineer.show_normal_dialogue(level_dialogue, "engineer_opening_lines")

func _making_a_choice(_players_choice):
	var correct_choice: bool
	objects_scanned_in_total += 1
	for square in object_controller.color_palette_squares:
		square.visible = false
	if (_players_choice == object_controller.current_object_acceptable):
		print("You are correct!")
		correct_choice = true
		objects_scanned_correctly += 1
	else:
		print("Wrong answer!")
		correct_choice = false
	match objects_scanned_in_total:
		4:
			if correct_choice == true:
				await engineer.show_normal_dialogue(level_dialogue, "first_feedback_correct")
			else:
				await engineer.show_normal_dialogue(level_dialogue, "first_feedback_incorrect")
	#_stats()
	
func _introducing_next_object():
	_accept_button_activated(false)
	_reject_button_activated(false)
	_object_info_updated()
	object_controller.current_object_moving = true
	chosen_point = end_point
	await get_tree().create_timer(3.0).timeout
	chosen_point = central_point
	object_controller.show_new_object()
	_object_info_updated()
	await get_tree().create_timer(3.0).timeout
	#This is a temporary solution to prevent the button from appearing in the final section. There have to be better ways to fix this.
	if not (robot_stats.visible == false && objects_scanned_in_total > 5):
		_accept_button_activated(true)
		_reject_button_activated(true)

func _object_analysis_finished():
	_stats_activated(false)
	_accept_button_activated(false)
	_reject_button_activated(false)
	await engineer.engineer_coming_in()
	await get_tree().create_timer(1.0).timeout
	if (accuracy_rate >= 40):
		await engineer.show_normal_dialogue(level_dialogue, "all_objects_analyzed_correctly")
	else:
		#A placeholder that sends player back to main menu
		await engineer.show_normal_dialogue(level_dialogue, "all_objects_analyzed_incorrectly")
		

func _level_restart():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://game/gui/start_menu.tscn")
		
func _object_info_updated():
	#var _accuracy_color: Color = Color.WEB_GREEN
	accuracy_rate = (int(round((float(objects_scanned_correctly) / objects_scanned_in_total) * 100)))
	#This should probably be refractored to use colors from the function.
	if accuracy_rate > 40:
		accuracy_label.text = "Accuracy rate: [color=green]%s%%[/color]" % accuracy_rate
	elif accuracy_rate == 40:
		accuracy_label.text = "Accuracy rate: [color=orange]%s%%[/color]" % accuracy_rate
		if accuracy_warning_triggered == false:
			engineer.show_normal_dialogue(level_dialogue,"forty_percent_warning")
			accuracy_warning_triggered = true
	else:
		accuracy_label.text = "Accuracy rate: [color=red]%s%%[/color]" % accuracy_rate
		if accuracy_warning_triggered == false:
			engineer.show_normal_dialogue(level_dialogue,"forty_percent_warning")
			accuracy_warning_triggered = true
	_show_object_type()

func _show_object_type():
	if object_controller.current_object_moving == true:
		await get_tree().create_timer(0.2).timeout
		_show_object_type()
	else:
		object_type_label.text = "Object type: %s"	% object_controller.current_object.object_type_string

func _end_the_level():
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)

#Level story
func _booting_up_the_robot():
	object_controller.show_new_object()
	print("This object's index is ", object_controller.current_object_index)
	LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout
	await engineer.show_normal_dialogue(level_dialogue, "robot_booted_up")
	await engineer.engineer_coming_in()
	await engineer.show_normal_dialogue(level_dialogue, "explaining_the_mechanics")

func _tutorial_stage_passed():
	match objects_scanned_in_total:
		1:
			await engineer.show_normal_dialogue(level_dialogue, "tutorial_nice_apple_accepted")
			return
		2:
			await engineer.show_normal_dialogue(level_dialogue, "tutorial_bad_apple_rejected")
			return

func _preventing_initial_mistake():
		objects_scanned_in_total = objects_scanned_in_total - 1
		await engineer.show_normal_dialogue(level_dialogue, "incorrect_blocked_answer")

#UI
func _on_accept_button_pressed():
	object_accepted = true
	_making_a_choice(object_accepted)
	match objects_scanned_in_total:
		1:
			_tutorial_stage_passed()
		2:
			_preventing_initial_mistake()
			return
	_introducing_next_object()

func _on_reject_button_pressed():
	object_accepted = false
	_making_a_choice(object_accepted)
	_tutorial_stage_passed()
	_introducing_next_object()
	
func _accept_button_activated(activated: bool):
	accept_button.visible = activated
	
func _reject_button_activated(activated: bool):
	reject_button.visible = activated

func _stats_activated(activated: bool):
	robot_stats.visible = activated

#Miscellaneous

func _stats():
	print("Objects scanned in total: ", objects_scanned_in_total)
	print("Objects scanned correctly: ", objects_scanned_correctly)
	print("This object's index is ", object_controller.current_object_index)
	print("The current accuracy rate is ", accuracy_rate)
