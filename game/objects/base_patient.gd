class_name Patient
extends Sprite2D

@export var patient_information: PatientData

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	
	if not patient_information:
		return
	texture = patient_information.patient_sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
