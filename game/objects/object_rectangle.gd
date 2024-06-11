class_name ObjectRectangle
extends StaticBody2D

@export var correct_type: AnalysisObjectData.ObjectTypes

@onready var object_type_label = %ObjectTypeLabel
@onready var presence_indicator = %PresenceIndicator

var rectangle_filled: bool = false
var current_card_reference: Node = null
var filled_correctly: bool = false

func _ready():
	object_type_label.text = "???????"

func add_object_card(suggested_type, suggested_type_string, card_ref):
	if suggested_type == correct_type:
		filled_correctly = true
	#Prevents card stacking when the rectangle is filled
	if current_card_reference == null:
		current_card_reference = card_ref
	rectangle_filled = true
	presence_indicator.visible = true
	object_type_label.text = tr(suggested_type_string)

func remove_object_card(card_ref):
	if card_ref == current_card_reference:
		filled_correctly = false
		current_card_reference = null
		presence_indicator.visible = false
		object_type_label.text = "???????"
		rectangle_filled = false
