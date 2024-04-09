class_name PaletteSquare
extends ColorRect


var color_dictionary = {AnalysisObjectData.ObjectTypeColors.NONE: Color.WEB_GRAY,
	AnalysisObjectData.ObjectTypeColors.BLACK: Color.BLACK,
	AnalysisObjectData.ObjectTypeColors.WHITE: Color.WHITE,
	AnalysisObjectData.ObjectTypeColors.RED: Color.RED,
	AnalysisObjectData.ObjectTypeColors.GREEN: Color.GREEN,
	AnalysisObjectData.ObjectTypeColors.BLUE: Color.BLUE,
	AnalysisObjectData.ObjectTypeColors.YELLOW: Color.YELLOW,
	AnalysisObjectData.ObjectTypeColors.ORANGE: Color.ORANGE,
	AnalysisObjectData.ObjectTypeColors.PINK: Color.PINK,
	AnalysisObjectData.ObjectTypeColors.BEIGE: Color.BEIGE,
	AnalysisObjectData.ObjectTypeColors.BROWN: Color.SADDLE_BROWN,
	AnalysisObjectData.ObjectTypeColors.PURPLE: Color.WEB_PURPLE
}

var chosen_color: Color


func create_design(determined_color: AnalysisObjectData.ObjectTypeColors):
	chosen_color = color_dictionary[determined_color]
	$InnerButton.color = chosen_color
	visible = true

func _on_gui_input(_event):
	if _event is InputEventMouseButton and _event.button_index == MOUSE_BUTTON_LEFT:
		if _event.pressed:
			print("Left mouse clicked on ", self)
		else:
			print("Left mouse released on ", self)

