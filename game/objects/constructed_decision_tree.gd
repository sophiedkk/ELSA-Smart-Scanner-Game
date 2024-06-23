class_name ConstructedDecisionTree
extends Node2D

signal tree_not_filled
signal tree_filled_correctly
signal tree_filled_incorrectly

#The first (zero) element is deliberately left as null so that the root count uses the same numbers as the loop
@export var tree_roots: Array[Node]
var current_root: int = 0
var tree_kids: Array[Node]
var current_tree_rects: Array[ObjectRectangle]
#Set to true by default and will switch to false if any of the rectangles aren't fit correctly
var tree_correct_fill: bool

#Creates a new tree based on the current root
func expose_new_tree():
	current_root += 1
	print("current root is", current_root)
	print("tree roots size is", tree_roots.size())
	if current_root >= tree_roots.size():
		return
	tree_roots[current_root].visible = true
	tree_kids = tree_roots[current_root].get_children()
	for tree_element in tree_kids:
		await get_tree().create_timer(0.2).timeout
		tree_element.visible = true
		if tree_element is ObjectRectangle:
			current_tree_rects.push_back(tree_element)

func check_correctness():
	#Checks if all rectangles are filled
	for rect in current_tree_rects:
		if rect.rectangle_filled == false:
			tree_not_filled.emit()
			return
	#Has to be re-assigned here to rid of previous calc results
	tree_correct_fill = true
	#Checks if rectangles are filled correctly
	for rect in current_tree_rects:
		if rect.filled_correctly == false:
			tree_correct_fill = false
	#Correct / incorrect fill
	if tree_correct_fill:
		tree_filled_correctly.emit()
	else:
		tree_filled_incorrectly.emit()

#Removes the tree currently present in the scene
func remove_current_tree():
	tree_kids.reverse()
	for tree_element in tree_kids:
		await get_tree().create_timer(0.2).timeout
		tree_element.visible = false
	tree_kids.clear()
	current_tree_rects.clear()
