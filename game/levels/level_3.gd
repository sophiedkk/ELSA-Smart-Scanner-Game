extends Level

#All patient data for UI
@export var level_patients: Array[PatientData]
#Control of the Submit Buttons
@export var hand_in_buttons: Array[SubmitButton]
#Patient container
@export var level_patient_object: PackedScene

#Controllers
@onready var engineer: Engineer = %Engineer
@onready var pill_controller: PillController = %PillController

@onready var pill_table = %PillTable
@onready var spawn_position = %SpawnPosition

#region result/analysis UI
@onready var analysis_background = %AnalysisBackground
@onready var analysis_status_UI = %AnalysisStatus
@onready var result_background = %ResultBackground
@onready var actual_outcome = %ActualOutcome
#endregion

#region Patient Data UI
@onready var all_patient_information = %AllPatientInformation
@onready var patient_information = %PatientInformation

@onready var patient_name = %PatientName
@onready var patient_age = %PatientAge
@onready var patient_gender = %PatientGender
@onready var patient_last_gp_visit = %PatientLastGPVisit
@onready var chronic_conditions = %ChronicConditions
@onready var recent_surgeries = %RecentSurgeries
@onready var known_allergies = %KnownAllergies
@onready var currently_pregnant = %CurrentlyPregnant
@onready var complaints = %Complaints
@onready var duration_of_symptoms = %DurationOfSymptoms
@onready var symptom_intensity = %SymptomIntensity
@onready var inferred_diagnosis = %InferredDiagnosis
#endregion

var current_patient_index: int = 0
var current_patient: Patient

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	await LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout
	await engineer.show_normal_dialogue(level_dialogue, "doctor_opening_lines")
	_refresh_sprite(true)
	engineer.engineer_coming_in()

#region Game Logic

func _connect_signals():
	engineer.initial_patient_dialogue.connect(_patient_pre_assessment_dialogue)
	engineer.spawn_the_pills.connect(_show_the_pills.bind(true))
	engineer.show_result_menu.connect(show_result_menu)
	engineer.call_the_engineer.connect(_final_engineer_dialogue)
	engineer.level_finished.connect(_end_level)
	for button in hand_in_buttons:
		button.relay_index.connect(make_a_pill_choice.bind(button.button_index))

func _patient_pre_assessment_dialogue():
	current_patient_index += 1
	if level_patients.size() <= current_patient_index:
		_final_doctor_dialogue()
		return
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
		2: 
			await engineer.show_normal_dialogue(level_dialogue, "karin_smits_intro")
		3:
			await engineer.show_normal_dialogue(level_dialogue, "inge_yassin_intro")
		4:
			await engineer.show_normal_dialogue(level_dialogue, "jan_muller_intro")

func make_a_pill_choice(chosen_button_index: int):
	await LevelTransition.fade_to_black()
	_show_the_pills(false)
	_show_the_hand_ins(false)
	
	#A very convoluted but accessible way to get a prompt for the next round
	var pill = pill_controller.children_pill_objects[chosen_button_index-1]
	pill.current_rating_display.text = "[center]%s[/center]" % tr(pill.pill_rec_for_patient[current_patient_index+1])
	pill.current_rating_display.visible = true
	
	await get_tree().create_timer(1.5).timeout
	var dialogue_name: String = ""
	match current_patient_index:
		1:
			dialogue_name = "hans_de_vries_choice_" + str(chosen_button_index)
		2:
			dialogue_name = "karin_smits_choice_" + str(chosen_button_index)
		3:
			dialogue_name = "inge_yassin_choice_" + str(chosen_button_index)
		4:
			dialogue_name = "jan_muller_choice_" + str(chosen_button_index)
	await engineer.show_normal_dialogue(level_dialogue, dialogue_name)
	analysis_background.visible = false
	pill_table.visible = false
	all_patient_information.visible = false
	current_patient.queue_free()

func _on_next_patient_pressed():
	await LevelTransition.fade_to_black()
	result_background.visible = false
	_patient_pre_assessment_dialogue()

func _refresh_sprite(is_doctor: bool):
	var new_texture = load("res://assets/images/doctor_lady.png") if is_doctor else load("res://assets/images/scientist_lady.png")
	engineer.current_sprite.texture = new_texture
#endregion
	
#region Level story
func _final_doctor_dialogue():
	await LevelTransition.fade_from_black()
	engineer.engineer_coming_in()
	await get_tree().create_timer(1.5).timeout
	await engineer.show_normal_dialogue(level_dialogue, "doctor_closing_lines")
	
func _final_engineer_dialogue():
	await get_tree().create_timer(3.5).timeout
	_refresh_sprite(false)
	engineer.engineer_coming_in()
	await engineer.show_normal_dialogue(level_dialogue, "engineer_closing_lines")

func end_the_level():
	_end_level()	
#endregion

#region GUI
func show_result_menu(correct_result: bool):
	actual_outcome.text = "GOOD_RESULT" if correct_result else "BAD_RESULT"
	result_background.visible = true
	await LevelTransition.fade_from_black()

func _show_the_pills(status: bool):
	pill_controller.visible = status
	_show_the_hand_ins(status)

func _show_the_hand_ins(status: bool):
	if (status):
		await get_tree().create_timer(1.5).timeout
	for button in hand_in_buttons:
		button.visible = status

func update_patient_card(current_data: PatientData):
	var complaints_string: String = ""
	complaints_string.left(0)
	patient_name.text = tr("PATIENT_NAME") + current_data.patient_name
	patient_age.text = tr("PATIENT_AGE") + str(current_data.patient_age)
	patient_gender.text = tr("PATIENT_GENDER") + tr(current_data.patient_gender)
	patient_last_gp_visit.text = tr("PATIENT_GP_VISIT") + current_data.last_gp_visit
	chronic_conditions.text = tr("PATIENT_CHRONIC_CONDITIONS") + tr(current_data.chronic_conditions)
	recent_surgeries.text = tr("PATIENT_RECENT_SURGERIES") + current_data.recent_sugeries
	known_allergies.text = tr("PATIENT_KNOWN_ALLERGIES") + tr(current_data.known_allergies)
	var eval_pregnancy: String = tr("PATIENT_YES") if current_data.currently_pregnant == 0 else tr("PATIENT_NO")
	currently_pregnant.text = tr("PATIENT_CURRENTLY_PREGNANT") + eval_pregnancy
	for complaint in current_data.patient_complaints:
		var complaint_translated = tr(complaint)
		complaints_string += complaint_translated + ", "
	complaints_string = complaints_string.left(complaints_string.length() - 2)
	complaints.text = tr("PATIENT_COMPLAINTS") + complaints_string
	duration_of_symptoms.text = tr("PATIENT_SYMPTOM_DURATION") + "~" + tr(current_data.symptoms_duration)
	symptom_intensity.text = tr("PATIENT_SYMPTOM_INTENSITY") + current_data.assessed_intensity
	inferred_diagnosis.text = tr("PATIENT_INFERRED_DIAGNOSIS") + tr(current_data.inferred_diagnosis)
#endregion
