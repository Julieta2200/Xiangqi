extends Node2D

var board_position: Vector2
@onready var highlighted_spot = $highlighted_spot
@onready var selected_highlight = $selected_highlight
@onready var free_marker_highlight: Sprite2D = $free_marker_highlight

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		if $highlight.visible:
			$"../../..".move(self)
		if free_marker_highlight.visible:
			$"../../..".selected_editor_marker(self)
			

func highlight():
	$highlight.visible = true

func unhighlight():
	$highlight.visible = false
	$trajectory_highlight.visible = false
	selected_highlight.visible = false
	free_marker_highlight.visible = false

func trajectory_highlight():
	$trajectory_highlight.visible = true
