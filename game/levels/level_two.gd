extends Node2D

@onready var engineer = %Engineer
@onready var object_analyzer = %ObjectAnalyzer
@onready var decision_tree = %ConstructedDecisionTree

@export var level_dialogue: DialogueResource

func _ready():
	_establishing_signal_connections()
	
	await LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout
	await engineer.show_normal_dialogue(level_dialogue, "rensselaer_opening_lines")
	engineer.engineer_coming_in()

func _establishing_signal_connections():
	engineer.tree_created.connect(_create_decision_tree)

func _create_decision_tree():
	decision_tree.expose_new_tree()
	if (decision_tree.current_root == 1):
		await engineer.show_normal_dialogue(level_dialogue, "introduction_to_decision_trees")
#func _process(_delta):
	#if Input.is_action_just_released("trigger_function"):
		#object_analyzer._switching_the_type()
		#object_analyzer._spawning_the_objects()
		#if object_analyzer.current_type == AnalysisObjectData.ObjectTypes.APPLE:
			#engineer.show_normal_dialogue(level_dialogue, "introduction_to_decision_trees")
