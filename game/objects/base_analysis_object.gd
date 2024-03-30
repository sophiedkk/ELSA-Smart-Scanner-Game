class_name BaseObject
extends Sprite2D

@export var object_properties: AnalysisObjectData

var type: AnalysisObjectData.ObjectTypes
var suitable: bool
var colors: Array[AnalysisObjectData.ObjectTypeColors]
var relevant_colors: Array[AnalysisObjectData.ObjectTypeColors]
var defects: bool



func _ready():
	set_process_input(true)

	if not object_properties:
		return
	texture = object_properties.object_texture
	type = object_properties.object_type
	suitable = object_properties.object_suitable
	colors = object_properties.object_type_colors
	relevant_colors = object_properties.object_relevant_colors
	defects = object_properties.object_defects
