class_name Level
extends Node

@export var next_level: PackedScene
@export var level_dialogue: DialogueResource


func _ready() -> void:
	_connect_signals()
	await LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout


func _connect_signals() -> void:
	pass


func _end_the_level():
	if not next_level: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
