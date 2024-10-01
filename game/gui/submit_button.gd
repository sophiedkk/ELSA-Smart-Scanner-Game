class_name SubmitButton
extends Button

signal relay_index(value)

@export var button_index: int

func _on_pressed():
	relay_index.emit()
