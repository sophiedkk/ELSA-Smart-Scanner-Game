extends Node2D

@export var level_objects: Array[PackedScene]
var current_object_index = 0
var current_object: Node
#signal new_object_chosen
#var color_button_path = load("res://Scenes/Other/color_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if level_objects != null:
		#show_new_object()

func show_new_object():
	if (get_child_count() != 0):
		get_child(0).queue_free()
	if (current_object_index < len(level_objects)):
		var object_path = load(level_objects[current_object_index].resource_path)
		current_object = object_path.instantiate()
		#var color_button = color_button_path.instantiate()
		#add_child(color_button)
		add_child(current_object)
		#new_object_chosen.emit()
		current_object_index = current_object_index + 1

