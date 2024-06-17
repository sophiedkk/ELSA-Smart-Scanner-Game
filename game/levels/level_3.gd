extends Level

#All patient data for UI
@export var level_patients: Array[PatientData]
#Control of the Submit Buttons
@export var hand_in_buttons: Array[SubmitButton]
#Patient container
@export var level_patient_object: PackedScene

@onready var engineer: Engineer = %Engineer
@onready var pill_table = %PillTable
@onready var analysis_background = %AnalysisBackground
@onready var all_patient_information = %AllPatientInformation
@onready var patient_information = %PatientInformation
@onready var spawn_position = %SpawnPosition
@onready var pill_controller: PillController = %PillController
@onready var analysis_status_UI = %AnalysisStatus

#region Patient Data UI
@onready var patient_name = %PatientName
@onready var patient_age = %PatientAge
@onready var patient_gender = %PatientGender
@onready var patient_last_gp_visit = %PatientLastGPVisit
@onready var chronic_conditions = %ChronicConditions
@onready var recent_surgeries = %RecentSurgeries
@onready var known_allergies = %KnownAllergies
@onready var currently_pregnant = %CurrentlyPregnant
#endregion

var current_patient_index: int = 0
var current_patient: Patient

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	_refresh_sprite()
	await LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout
	await engineer.show_normal_dialogue(level_dialogue, "doctor_opening_lines")
	engineer.engineer_coming_in()

#func _process(_delta):
	#if Input.is_action_just_released("skip_level"):
		#_end_level()

func _connect_signals():
	engineer.initial_patient_dialogue.connect(_patient_pre_assessment_dialogue)
	engineer.spawn_the_pills.connect(_show_the_pills.bind(true))
	engineer.restore_UI.connect(restore_UI_elements)
	pill_controller.all_pills_analysed.connect(_show_the_hand_ins.bind(true))
	pill_controller.trigger_pill_dialogue.connect(_show_pill_analysis_dialogue)
	for button in hand_in_buttons:
		button.relay_index.connect(make_a_pill_choice.bind(button.button_index))
	
func _patient_pre_assessment_dialogue():
	current_patient_index += 1
	if current_patient != null:
		current_patient.queue_free()
	analysis_background.visible = true
	pill_table.visible = true
	
	current_patient = level_patient_object.instantiate()
	current_patient.patient_information = level_patients[current_patient_index]
	current_patient.position = spawn_position.position
	add_child(current_patient)
	
	update_patient_card(current_patient.patient_information)
	
	await get_tree().create_timer(2.0).timeout
	all_patient_information.visible = true
	match current_patient_index:
		1:
			await engineer.show_normal_dialogue(level_dialogue, "hans_de_vries_intro")
	pass

func _show_the_pills(status: bool):
	pill_controller.visible = status

func _show_the_hand_ins(status: bool):
	if (status):
		await get_tree().create_timer(1.5).timeout
	for button in hand_in_buttons:
		button.visible = status

func _show_pill_analysis_dialogue(analysed_pill_index: int):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	all_patient_information.visible = false
	analysis_status_UI.text = "ANALYSING_DATABASE"
	analysis_status_UI.visible = true
	await get_tree().create_timer(2.5).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	analysis_status_UI.text = "PREDICTED_OUTCOME"
	for pill in pill_controller.children_pill_objects:
		if pill.pill_level_index == analysed_pill_index:
			pill.post_analysis_results()
	match current_patient_index:
		1:
			match analysed_pill_index:
				#Refactor, possibly through string concatenation
				1:
					await engineer.show_normal_dialogue(level_dialogue,"hans_de_vries_expected_result_1")
				2:
					await engineer.show_normal_dialogue(level_dialogue,"hans_de_vries_expected_result_2")
				3:
					await engineer.show_normal_dialogue(level_dialogue,"hans_de_vries_expected_result_3")
				4:
					await engineer.show_normal_dialogue(level_dialogue,"hans_de_vries_expected_result_4")

func restore_UI_elements():
	analysis_status_UI.visible = false
	all_patient_information.visible = true
	pass

func _refresh_sprite():
	var new_texture = load("res://assets/images/doctor_lady.png")
	engineer.current_sprite.texture = new_texture

func make_a_pill_choice(chosen_button_index: int):
	await LevelTransition.fade_to_black()
	for pill in pill_controller.children_pill_objects:
		pill.current_rating_display.visible = false
	_show_the_pills(false)
	_show_the_hand_ins(false)
	await get_tree().create_timer(1.5).timeout
	match current_patient_index:
		1:
			match chosen_button_index:
				1:
					await engineer.show_normal_dialogue(level_dialogue, "hans_de_vries_choice_1")
				2:
					await engineer.show_normal_dialogue(level_dialogue, "hans_de_vries_choice_2")
				3:
					await engineer.show_normal_dialogue(level_dialogue, "hans_de_vries_choice_3")
				4:
					await engineer.show_normal_dialogue(level_dialogue, "hans_de_vries_choice_4")
	analysis_background.visible = false
	pill_table.visible = false
	all_patient_information.visible = false
	current_patient.queue_free()

func update_patient_card(current_data: PatientData):
	patient_name.text = "Name: " + current_data.patient_name
	patient_age.text = "Age: " + str(current_data.patient_age)
	patient_gender.text = "Gender: " + current_data.patient_gender
	patient_last_gp_visit.text = "Last GP visit: " + current_data.last_gp_visit
	chronic_conditions.text = "Chronic conditions: " + current_data.chronic_conditions
	recent_surgeries.text = "Recent surgeries: " + current_data.recent_sugeries
	known_allergies.text = "Known allergies: " + current_data.known_allergies
	var eval_pregnancy: String = "yes" if current_data.currently_pregnant == 0 else "no"
	currently_pregnant.text = "Currently pregnant: " + eval_pregnancy
