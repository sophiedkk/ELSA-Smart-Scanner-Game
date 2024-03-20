extends Node2D

@export var level_objects: Array[PackedScene]
var current_object_number = 0
#var color_button_path = load("res://Scenes/Other/color_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if level_objects != null:
		#show_new_object()

func show_new_object():
	if (get_child_count() != 0):
		get_child(0).queue_free()
	if (current_object_number < len(level_objects)):
		var object_path = load(level_objects[current_object_number].resource_path)
		var current_object = object_path.instantiate()
		#var color_button = color_button_path.instantiate()
		#add_child(color_button)
		add_child(current_object)
		current_object_number = current_object_number + 1
