extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var blacked_out: bool = false


func fade_from_black():
	animation_player.play("fade_from_black")
	await animation_player.animation_finished
	blacked_out = false


func fade_to_black():
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	blacked_out = true


func default_black_screen():
	animation_player.play("default_black_screen")
	await animation_player.animation_finished
