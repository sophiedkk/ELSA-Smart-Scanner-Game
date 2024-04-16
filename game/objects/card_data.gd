class_name CardData
extends Resource

@export_group("Object Properties")
@export var card_texture: Texture2D
@export var card_type: AnalysisObjectData.ObjectTypes

var card_types_as_strings = {
	AnalysisObjectData.ObjectTypes.NONE: "None",
	AnalysisObjectData.ObjectTypes.APPLE: "Apple",
	AnalysisObjectData.ObjectTypes.BANANA: "Banana",
	AnalysisObjectData.ObjectTypes.GRAPES: "Grapes",
	AnalysisObjectData.ObjectTypes.CHILI: "Chili",
	AnalysisObjectData.ObjectTypes.COCONUT: "Coconut"
}
