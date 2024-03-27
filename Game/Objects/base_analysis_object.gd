extends Sprite2D
class_name BaseObject

@export var object_properties: AnalysisObjectData

func _ready():
	set_process_input(true)
	texture = object_properties.object_texture
