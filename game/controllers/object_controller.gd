extends Node2D
class_name ObjectController

#Potentially this can be rearranged into an array of resources instead?
#So you load the default empty object and then put the resource into it
@export var level_objects: Array[PackedScene]
var current_object_index = 0
var current_object: BaseObject
var current_object_acceptable: bool

#Reference to the colors in the enumerator of the object
var color_palette: Array[AnalysisObjectData.ObjectTypeColors]
#Reference to the object scene that works as a button
@onready var color_palette_object: = preload("res://game/gui/color_rectangle.tscn")
#Reference to the object in the scene
var color_palette_square: PaletteSquare
#An array that stores squares currently presented on screen
var color_palette_squares: Array[PaletteSquare]

func show_new_object():
	if (current_object != null):
		current_object.queue_free()
	if (current_object_index < len(level_objects)):
		var object_path = load(level_objects[current_object_index].resource_path)
		current_object = object_path.instantiate()
		add_child(current_object)
		clear_previous_palette()
		show_new_object_palette()
		current_object_acceptable = current_object.object_properties.object_suitable
		current_object_index = current_object_index + 1
	else:
		clear_previous_palette()
		print(color_palette, color_palette_squares)

func show_new_object_palette():
	if (current_object != null):
		color_palette = current_object.object_properties.object_type_colors
		print(color_palette)
		for i in range(len(color_palette)):
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
	if (color_palette_squares != null):
		for i in len(color_palette_squares):
			color_palette_squares[i].queue_free()
		color_palette.clear()
		#Not sure if I have to clear the array here
		color_palette_squares.clear()
