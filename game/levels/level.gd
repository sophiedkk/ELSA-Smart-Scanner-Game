class_name Level
extends Node

@export var next_level: PackedScene
@export var level_dialogue: DialogueResource


func _ready() -> void:
	TranslationServer.set_locale(Global.current_locale)
	_connect_signals()


func _connect_signals() -> void:
	pass


func _end_level():
	if not next_level:
		await LevelTransition.fade_to_black()
		get_tree().change_scene_to_file("res://game/gui/start_menu.tscn")
		await LevelTransition.fade_from_black()
	else:
		await LevelTransition.fade_to_black()
		get_tree().paused = false
		get_tree().change_scene_to_packed(next_level)

func _restart_level():
	await LevelTransition.fade_to_black()
	get_tree().reload_current_scene()
