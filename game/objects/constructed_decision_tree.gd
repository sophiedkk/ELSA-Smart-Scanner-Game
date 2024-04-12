class_name ConstructedDecisionTree
extends Node2D

#The first (zero) element is deliberately left as null so that the root count uses the same numbers as the loop
@export var tree_roots: Array[Node]
var current_root: int = 0
var tree_kids: Array[Node]

#Creates a new tree based on the current root
func expose_new_tree():
	current_root += 1
	tree_roots[current_root].visible = true
	tree_kids = tree_roots[current_root].get_children()
	for tree_element in tree_kids:
		await get_tree().create_timer(0.2).timeout
		tree_element.visible = true

#Removes the tree currently present in the scene
func remove_current_tree():
	tree_kids.reverse()
	for tree_element in tree_kids:
		await get_tree().create_timer(0.2).timeout
		tree_element.visible = false
	tree_kids.clear()
