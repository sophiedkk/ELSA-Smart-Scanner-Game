class_name ObjectRectangle
extends StaticBody2D

@onready var object_type_label = %ObjectTypeLabel
@onready var presence_indicator = %PresenceIndicator

var rectangle_filled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	object_type_label.text = "???????"

func add_object_card(suggested_type):
	rectangle_filled = true
	presence_indicator.visible = true
	object_type_label.text = suggested_type

func remove_object_card():
	rectangle_filled = false
	presence_indicator.visible = false
	object_type_label.text = "???????"
