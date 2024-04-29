class_name BaseCard
extends Node2D

@export var card_properties: CardData

var card_type: AnalysisObjectData.ObjectTypes
var card_type_string: String

var draggable: bool = false
var is_inside_droppable: bool = false
var body_ref: ObjectRectangle
var overlap_count: int = 0

var offset: Vector2
var initialPos: Vector2

@onready var card_area: Area2D = %CardArea
@onready var card_sprite: Sprite2D = %ObjectSprite


func _ready():
	set_process_input(true)

	if not card_properties:
		return
	card_sprite.texture = card_properties.card_texture
	card_type = card_properties.card_type
	card_type_string = card_properties.card_types_as_strings[card_type]
	initialPos = global_position


func _process(_delta):
	if draggable:
		if Input.is_action_just_pressed("click_object"):
			card_sprite.visible = true
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
		if Input.is_action_pressed("click_object"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("click_object"):
			Global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_droppable && body_ref.rectangle_filled == false:
				body_ref.add_object_card(card_type, card_type_string, self)
				tween.tween_property(self, "position", body_ref.global_position, 0.002).set_ease(Tween.EASE_OUT)
				card_sprite.visible = false
			else:
				#print("Is inside droppable: ", is_inside_droppable)
				#print("Rect filled: ", body_ref.rectangle_filled)
				tween.tween_property(self, "position", initialPos, 0.002).set_ease(Tween.EASE_OUT)


func _on_area_2d_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)


func _on_area_2d_mouse_exited():
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1, 1)


func _on_area_2d_body_entered(body: ObjectRectangle):
	if body.is_in_group("dropable") and body.visible:
		overlap_count += 1
		is_inside_droppable = true
		body_ref = body


func _on_area_2d_body_exited(body: ObjectRectangle):
	if body.is_in_group("dropable") and body.visible:
		overlap_count -= 1
		if overlap_count == 0:
			is_inside_droppable = false
		body.remove_object_card(self)


func change_draggability():
	card_area.visible = !card_area.visible
