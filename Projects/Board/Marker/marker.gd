class_name BoardMarker extends Node2D

var board_position: Vector2
@onready var free_marker_highlight: Sprite2D = $free_marker_highlight

signal figure_move(marker)
signal figure_set(marker)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		if $highlight.visible or $capture_highlight.visible:
			emit_signal("figure_move",self)
		elif free_marker_highlight.visible:
			emit_signal("figure_set",self)
			

func highlight(busy: bool = false):
	if !busy:
		$highlight.show()
	else:
		$capture_highlight.show()

func unhighlight():
	$highlight.hide()
	$capture_highlight.hide()
	$selected_highlight.hide()
	free_marker_highlight.hide()

func selected_highlight():
	$selected_highlight.show()
