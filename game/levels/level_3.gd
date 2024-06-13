extends Level

@export var level_patients: Array[PatientData]
@export var level_patient_object: PackedScene

@onready var engineer: Engineer = %Engineer
@onready var pill_table = %PillTable
@onready var analysis_background = %AnalysisBackground
@onready var patient_information = %PatientInformation
@onready var spawn_position = %SpawnPosition
@onready var pill_controller = %PillController

@onready var patient_name = %PatientName
@onready var patient_age = %PatientAge
@onready var patient_gender = %PatientGender
@onready var patient_last_gp_visit = %PatientLastGPVisit
@onready var chronic_conditions = %ChronicConditions
@onready var recent_surgeries = %RecentSurgeries
@onready var known_allergies = %KnownAllergies
@onready var currently_pregnant = %CurrentlyPregnant


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
	engineer.spawn_the_pills.connect(_show_the_pills)
	
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
	patient_information.visible = true
	match current_patient_index:
		1:
			await engineer.show_normal_dialogue(level_dialogue, "hans_de_vries_intro")
	pass

func _show_the_pills():
	pill_controller.visible = true

func _refresh_sprite():
	var new_texture = load("res://assets/images/doctor_lady.png")
	engineer.current_sprite.texture = new_texture

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
