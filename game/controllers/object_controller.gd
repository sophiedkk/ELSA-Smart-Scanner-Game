class_name ObjectController
extends Node2D

signal all_objects_passed

@export var level_object_scene: PackedScene
@export var level_objects: Array[AnalysisObjectData]

var current_object_index = 0
var current_object: BaseObject
var current_object_moving: bool = false
var current_object_acceptable: bool
#Reference to the colors in the enumerator of the object
var color_palette: Array[AnalysisObjectData.ObjectTypeColors]
#Reference to the object in the scene
var color_palette_square: PaletteSquare
#An array that stores squares currently presented on screen
var color_palette_squares: Array[PaletteSquare]


#Reference to the object scene that works as a button
@onready var color_palette_object: = preload("res://game/gui/color_rectangle.tscn")


func show_new_object():
	if current_object != null:
		current_object.queue_free()

	var new_object_properties = level_objects.pop_front()
	if new_object_properties:
		current_object = level_object_scene.instantiate()
		current_object.object_properties = new_object_properties
		add_child(current_object)
		clear_previous_palette()
		show_new_object_palette()
		current_object_acceptable = current_object.suitable
		current_object_index = current_object_index + 1
		current_object_moving = true
	else:
		clear_previous_palette()
		all_objects_passed.emit()

func move_current_object(delta, intended_destination: Node, move_speed: int, midi_point: bool):
	if current_object == null:
		return
	if current_object_moving:
		current_object.global_position = current_object.global_position.move_toward(intended_destination.global_position, delta*move_speed)
	if current_object.global_position == intended_destination.global_position:
		current_object_moving = false
		if midi_point == true:
			for palette in color_palette_squares:
				palette.visible = true

func show_new_object_palette():
	if current_object != null:
		color_palette = current_object.colors
		print(color_palette)
		for i in color_palette.size():
			color_palette_square = color_palette_object.instantiate()
			color_palette_square.create_design(color_palette[i])
			add_child(color_palette_square)
			#Will reorganize into a grid later
			color_palette_square.global_position = Vector2(130 + (i * 40), 40)
			color_palette_squares.push_back(color_palette_square)


func clear_previous_palette():
	if color_palette_squares != null:
		for square in color_palette_squares:
			square.queue_free()
		color_palette.clear()
		#Not sure if I have to clear the array here
		color_palette_squares.clear()
