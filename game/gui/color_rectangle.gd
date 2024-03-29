class_name PaletteSquare
extends ColorRect

var color_dictionary = [Color.WEB_GRAY,
Color.BLACK,Color.WHITE,Color.RED,
Color.GREEN,Color.BLUE, Color.YELLOW,
Color.ORANGE,Color.PINK,Color.BEIGE
]

var chosen_color: Color


func create_design(determined_color):
	chosen_color = color_dictionary[determined_color]
	$InnerButton.color = chosen_color
	visible = true

func _on_gui_input(_event):
	pass # Replace with function body.
