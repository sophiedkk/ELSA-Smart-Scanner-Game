class_name PillObject
extends Node2D

@export var lower_rating_limits: Array[int]
@export var upper_rating_limits: Array[int]
@export var colors_for_limits: Array[Color]

signal value_changed(updated_value)

var current_patient_index: int = 0

@onready var current_rating_display = %CurrentRatingDisplay
@onready var database_analysis_button = %DatabaseAnalysisButton
@onready var close_button = %CloseButton
@onready var black_background = %BlackBackground

func new_patient_index(new_value):
	current_patient_index = new_value
	value_changed.emit(new_value)

func set_rating(new_value):
	value_changed.emit(new_value)

func _on_pill_sprite_area_2d_input_event(viewport, event, shape_idx):
		if event.is_pressed():
			if(Global.current_pill == "" && Global.button_on == false):
				Global.current_pill = str(name)
				Global.button_on = true
				z_index = 4
				database_analysis_button.visible = true
				close_button.visible = true
				black_background.visible = true
			else:
				return

func _on_close_button_area_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		print(event)
		if (Global.current_pill == str(name) && Global.button_on):
			Global.current_pill = ""
			Global.button_on = false
			z_index = 3
			database_analysis_button.visible = false
			close_button.visible = false
			black_background.visible = false
			pass
			

func _on_value_changed(updated_value):
	#Prevents going out of bounds
	if (current_patient_index >= lower_rating_limits.size() || current_patient_index >= upper_rating_limits.size() || current_patient_index >= colors_for_limits.size()):
		return
	
	current_rating_display.visible = false
		
	current_rating_display.add_theme_color_override("default_color", colors_for_limits[current_patient_index])
	current_rating_display.text = "{" + str(lower_rating_limits[current_patient_index]) + ";" + str(upper_rating_limits[current_patient_index]) + "}"
	current_rating_display.visible = true
