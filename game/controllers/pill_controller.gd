class_name PillController
extends Node2D

@export var children_pill_objects: Array[PillObject]

signal all_pills_analysed
signal trigger_pill_dialogue(pill_level_index: int)

var current_patient_index: int = 0
var total_pills_analysed: int = 0

func check_pills_status():
	total_pills_analysed = 0
	for pill in children_pill_objects:
		if pill.has_been_analyzed:
			total_pills_analysed += 1
	if total_pills_analysed < children_pill_objects.size():
		return
	else:
		print("all pills analysed!!!")
		all_pills_analysed.emit()

#Midpoint in passing the pill information to the Engineer for dialogue
func display_simulation_results(pill_index: int):
	trigger_pill_dialogue.emit(pill_index)
	
#UNDER CONSTRUCTION!
func update_all_pill_info():
	current_patient_index += 1
	if children_pill_objects == null:
		return
	for pill_object in children_pill_objects:
		pill_object.new_patient_index(current_patient_index)
