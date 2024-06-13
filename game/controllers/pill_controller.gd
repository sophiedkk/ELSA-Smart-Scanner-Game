class_name PillController
extends Node2D

@export var children_pill_objects: Array[PillObject]

var current_patient_index: int = 0

#func _process(delta):
	#if Input.is_action_just_pressed("skip_level"):
		#update_all_pill_info()

#Definitely controls whether all of the pills have been checked

#UNDER CONSTRUCTION!
func update_all_pill_info():
	current_patient_index += 1
	if children_pill_objects == null:
		return
	for pill_object in children_pill_objects:
		pill_object.new_patient_index(current_patient_index)
