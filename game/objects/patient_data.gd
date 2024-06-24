class_name PatientData
extends Resource

enum YesNoStatus {yes, no}

#Base Info
@export var patient_name: String
@export var patient_age: int
#Changed to an enumerator later?
@export var patient_gender: String
@export var last_gp_visit: String
@export var chronic_conditions: String
@export var recent_sugeries: String
@export var known_allergies: String
@export var currently_pregnant: YesNoStatus
@export var patient_sprite: Texture2D

#Sickness / complaints
@export var patient_complaints: Array[String]
@export var symptoms_duration: String
@export var assessed_intensity: String
@export var surgery_required: YesNoStatus
@export var exotic_or_rare_signs: YesNoStatus
@export var inferred_diagnosis: String
