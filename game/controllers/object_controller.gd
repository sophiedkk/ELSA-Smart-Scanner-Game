class_name ObjectController
extends Node2D

@export var level_object_scene: PackedScene
@export var level_objects: Array[AnalysisObjectData]

var current_object_index = 0
var current_object: BaseObject
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
	else:
		clear_previous_palette()
		print(color_palette, color_palette_squares)


func show_new_object_palette():
	if current_object != null:
		color_palette = current_object.colors
		print(color_palette)
		for i in color_palette.size():
			color_palette_square = color_palette_object.instantiate()
			#This is a very bad idea, because this compares two integers
			#One is in the color rectangle object, another is derived from AnalysisObjectData
			#These, therefore, rely on the idea that the order of colors is the same
			#I cannot figure out a way to solve this with a dictionary because of how enums work
			color_palette_square.create_design(color_palette[i])
			add_child(color_palette_square)
			#Will reorganize into a grid later
			color_palette_square.position = Vector2(i * 40, -70)
			color_palette_squares.push_back(color_palette_square)


func clear_previous_palette():
	if color_palette_squares != null:
		for square in color_palette_squares:
			square.queue_free()
		color_palette.clear()
		#Not sure if I have to clear the array here
		color_palette_squares.clear()
