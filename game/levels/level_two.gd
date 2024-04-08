extends Node2D

@onready var engineer = %Engineer

@export var level_dialogue: DialogueResource

func _ready():
	await LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout
	engineer.show_normal_dialogue(level_dialogue, "rensselaer_opening_lines")
	engineer.engineer_coming_in()
