extends Node2D
class_name ObjectController

@export var level_objects: Array[PackedScene]
var current_object_index = 0
var current_object: BaseObject
var current_object_acceptable: bool
var color_palette_squares: Array[PaletteSquare]
#signal new_object_chosen
#var color_button_path = load("res://Scenes/Other/color_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if level_objects != null:
		#show_new_object()

func show_new_object():
	if (get_child_count() != 0):
		#get_child(0).queue_free()
		current_object.queue_free()
	if (current_object_index < len(level_objects)):
		var object_path = load(level_objects[current_object_index].resource_path)
		current_object = object_path.instantiate()
		add_child(current_object)
		show_new_object_palette()
		current_object_acceptable = current_object.object_properties.object_suitable
		current_object_index = current_object_index + 1
		print("Current object index is ", current_object_index)

func show_new_object_palette():
	var color_palette = current_object.object_properties.object_colors
	for color in color_palette:
		print(color)
		var square = load("res://Scenes/Other/color_button.tscn").instantiate()
		add_child(square)
		print(square.get_transform())
