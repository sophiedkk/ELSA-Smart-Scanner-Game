extends Node2D

@onready var engineer = %Engineer
@onready var object_analyzer = %ObjectAnalyzer

@export var level_dialogue: DialogueResource

func _ready():
	await LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout
	engineer.show_normal_dialogue(level_dialogue, "rensselaer_opening_lines")
	engineer.engineer_coming_in()

func _process(_delta):
	if Input.is_action_just_released("trigger_function"):
		object_analyzer._switching_the_type()
		object_analyzer._spawning_the_objects()
