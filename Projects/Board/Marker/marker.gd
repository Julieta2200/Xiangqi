class_name BoardMarker extends Node2D

var board_position: Vector2
@onready var free_marker_highlight: Sprite2D = $free_marker_highlight

signal figure_move(marker)
signal figure_set(marker)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		if $marker.visible or $capture_marker.visible:
			emit_signal("figure_move",self)
		elif free_marker_highlight.visible:
			emit_signal("figure_set",self)
			

func highlight(busy: bool = false):
	if !busy:
		$marker.show()
	else:
		$capture_marker.show()

func unhighlight():
	$marker.hide()
	$capture_marker.hide()
	free_marker_highlight.hide()


func _on_area_2d_mouse_entered() -> void:
	$marker/highlight.visible = $marker.visible
	$capture_marker/highlight.visible = $capture_marker.visible


func _on_area_2d_mouse_exited() -> void:
	$marker/highlight.hide()
	$capture_marker/highlight.hide()
