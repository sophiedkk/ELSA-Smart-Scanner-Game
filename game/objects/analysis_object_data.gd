class_name AnalysisObjectData
extends Resource

enum ObjectTypes {NONE, APPLE, BANANA, PEAR, BERRY, CARROT, SALAD, CHOCOLATE,
SANDWICH, JUICE, GRAPES}

enum ObjectTypeColors {NONE, BLACK, WHITE, RED, GREEN, BLUE, YELLOW, ORANGE, PINK, BEIGE, BROWN, PURPLE}

var object_types_as_strings = {
	ObjectTypes.NONE: "None",
	ObjectTypes.APPLE: "Apple",
	ObjectTypes.BANANA: "Banana",
	ObjectTypes.PEAR: "Pear",
	ObjectTypes.BERRY: "Berry",
	ObjectTypes.CARROT: "Carrot",
	ObjectTypes.SALAD: "Salad",
	ObjectTypes.CHOCOLATE: "Chocolate",
	ObjectTypes.SANDWICH: "Sandwich",
	ObjectTypes.JUICE: "Juice",
	ObjectTypes.GRAPES: "Grapes"
}

@export_group("Level 1 Properties")
@export var object_texture: Texture2D
@export var object_type: ObjectTypes
@export var object_suitable: bool = true
@export var object_type_colors: Array[ObjectTypeColors]
#Technically speaking, this is incorrect
#The objects themselves will obviously have colors of the defects on them
#However, that is irrelevant since this variable is only used to check the palettes
@export var object_relevant_colors: Array[ObjectTypeColors]

@export_group("Level 3 properties")
@export var object_defects := false
# Not sure how to handle object_defect_area,
# Export does not support classes derived from Node in the Resource section
#Probably goes within the object itself then

@export_group("Level 4 Properties")
#Potentially some property for the outline itself?
@export_global_file("*.png", "*.jpg") var object_outline_asset

