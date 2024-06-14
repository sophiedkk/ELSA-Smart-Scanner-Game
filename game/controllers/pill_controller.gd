class_name PillController
extends Node2D

@export var children_pill_objects: Array[PillObject]

signal all_pills_analysed

var current_patient_index: int = 0
var total_pills_analysed: int = 0

func _ready():
	for pill in children_pill_objects:
		pill.pill_analysed.connect(check_pills_status)

#Definitely controls whether all of the pills have been checked
func check_pills_status():
	total_pills_analysed = 0
	for pill in children_pill_objects:
		if pill.has_been_analyzed:
			total_pills_analysed += 1
	if total_pills_analysed < children_pill_objects.size():
		return
	else:
		all_pills_analysed.emit()

#UNDER CONSTRUCTION!
func update_all_pill_info():
	current_patient_index += 1
	if children_pill_objects == null:
		return
	for pill_object in children_pill_objects:
		pill_object.new_patient_index(current_patient_index)
