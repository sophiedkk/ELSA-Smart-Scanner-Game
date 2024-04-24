class_name ObjectAnalyzer
extends Node2D

#Main array with all of the objects
@export var all_objects_data: Array[AnalysisObjectData]
#Base object file
@export var base_object_scene: PackedScene

#All possible object types
var all_types: Array[AnalysisObjectData.ObjectTypes] = [AnalysisObjectData.ObjectTypes.NONE,
AnalysisObjectData.ObjectTypes.APPLE,
AnalysisObjectData.ObjectTypes.BANANA,
AnalysisObjectData.ObjectTypes.PEAR,
AnalysisObjectData.ObjectTypes.BERRY,
AnalysisObjectData.ObjectTypes.CARROT,
AnalysisObjectData.ObjectTypes.SALAD,
AnalysisObjectData.ObjectTypes.CHOCOLATE,
AnalysisObjectData.ObjectTypes.SANDWICH,
AnalysisObjectData.ObjectTypes.JUICE
]
#Data relevant to the current object type
var current_type: AnalysisObjectData.ObjectTypes
var current_type_objects_data: Array[AnalysisObjectData]
var current_type_int: int = 0

#Reference to the colors in the enumerator of the object
var color_palette: Array[AnalysisObjectData.ObjectTypeColors]
#Reference to the object in the scene
var color_palette_square: PaletteSquare
#An array that stores squares currently presented on screen
var color_palette_squares: Array[PaletteSquare]

#Actual in-game objects that contain the data
var spawned_objects: Array[BaseObject]

@onready var color_palette_object: = preload("res://game/gui/color_rectangle.tscn")
@onready var tick_sign: = preload("res://assets/images/tick.png")
@onready var cross_sign: = preload("res://assets/images/cross.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	current_type = all_types[0]
	print(color_palette_object)

func _switching_the_type():
	if current_type_objects_data != null:
		current_type_objects_data.clear()
	#This can probably be switched to pop_front(), but I'm not sure if the list may be needed in case of a restart
	current_type_int += 1
	current_type = all_types[current_type_int]
	for object_data in all_objects_data:
		if object_data.object_type == current_type:
			current_type_objects_data.push_back(object_data)

func _spawning_the_objects():
	_clear_previous_objects()
	for i in current_type_objects_data.size():
		var passability_sign = Sprite2D.new()
		var current_object = base_object_scene.instantiate()
		var current_object_properties = current_type_objects_data[i]
		current_object.object_properties = current_object_properties
		spawned_objects.push_back(current_object)
		add_child(current_object)
		if current_object != null:
			color_palette = current_object.object_properties.object_relevant_colors
			print(color_palette)
		for j in color_palette.size():
			color_palette_square = color_palette_object.instantiate()
			color_palette_square.create_design(color_palette[j])
			current_object.add_child(color_palette_square)
			color_palette_square.scale = Vector2(10, 10)
			color_palette_square.position = Vector2((j * 450) - 500, -900)
			color_palette_squares.push_back(color_palette_square)
		current_object.position = Vector2(i * 90, 0)
		if current_object_properties.object_suitable == true:
			passability_sign.texture = tick_sign
		else:
			passability_sign.texture = cross_sign
		current_object.add_child(passability_sign)
		passability_sign.position = Vector2(0, -1200)


func _clear_previous_objects():
		if spawned_objects != null:
			for object in spawned_objects:
				object.queue_free()
		spawned_objects.clear()
