class_name AnalysisObjectData
extends Resource

enum ObjectTypes {NONE, APPLE, BANANA, PEAR, BERRY, CARROT, SALAD, CHOCOLATE,
SANDWICH, JUICE, GRAPES, CHILI, COCONUT}

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
	ObjectTypes.GRAPES: "Grapes",
	ObjectTypes.CHILI: "Chili",
	ObjectTypes.COCONUT: "Coconut"
}

@export_group("Level 1 Properties")
@export var object_texture: Texture2D
@export var object_type: ObjectTypes
@export var object_suitable: bool = true
@export var object_type_colors: Array[ObjectTypeColors]
@export var object_relevant_colors: Array[ObjectTypeColors]



