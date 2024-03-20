extends Node2D

@onready var object_controller = %ObjectController

func _on_reject_button_pressed():
	object_controller.show_new_object()

func _on_accept_button_pressed():
	object_controller.show_new_object()
