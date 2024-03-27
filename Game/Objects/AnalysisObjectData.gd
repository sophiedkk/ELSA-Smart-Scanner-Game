class_name AnalysisObjectData
extends Resource

enum ObjectTypes {NONE, APPLE, BANANA, PEAR, BERRY, CARROT, SALAD, CHOCOLATE,
SANDWICH, JUICE}

enum ObjectColors {NONE, BLACK, WHITE, RED, GREEN, BLUE, YELLOW, ORANGE, PINK, BEIGE}

@export_group("Level 1 Properties")
@export var object_texture: Texture2D
@export var object_type: ObjectTypes
@export var object_suitable: bool = true
@export var object_colors: Array[ObjectColors]

@export_group("Level 2 Properties")
@export var object_defects = false
# Not sure how to handle object_defect_area, 
# Export does not support classes derived from Node in the Resource section
#Probably goes within the object itself then

@export_group("Level 3 Properties")
#Potentially some property for the outline itself?
@export_global_file("*.png", "*.jpg") var object_outline_asset


func _init():
	pass
