extends Level

@onready var engineer: Engineer = %Engineer

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_texture = load("res://assets/images/doctor_lady.png")
	engineer.current_sprite.texture = new_texture
	await LevelTransition.fade_from_black()
	await get_tree().create_timer(0.5).timeout
	await engineer.show_normal_dialogue(level_dialogue, "doctor_opening_lines")
	engineer.engineer_coming_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
