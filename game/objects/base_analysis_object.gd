class_name BaseObject
extends Sprite2D

@export var object_properties: AnalysisObjectData


func _ready():
	set_process_input(true)
	texture = object_properties.object_texture
