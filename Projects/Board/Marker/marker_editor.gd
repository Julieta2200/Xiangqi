class_name MarkerEditor extends Node2D


var board_position: Vector2

signal selected_marker(MarkerEditor)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		emit_signal("selected_marker", self)
