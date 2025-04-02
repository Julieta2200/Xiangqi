class_name BoardMarker extends Node2D

var board_position: Vector2
@onready var position_marker: AnimatedSprite2D = $position_marker
@onready var horizontal_line: Sprite2D = $position_marker/horizontal_line
@onready var vertical_line: Sprite2D = $position_marker/vertical_line


signal figure_move(marker)
signal figure_set(marker)
signal highlight_end

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		if $marker.visible or $capture_marker.visible:
			emit_signal("figure_move",self)
		elif position_marker.visible:
			emit_signal("figure_set",self)
			position_marker_light()
			

func highlight(busy: bool = false):
	if !busy:
		$marker.show()
	else:
		$capture_marker.show()

func unhighlight():
	$marker.hide()
	$capture_marker.hide()

func _on_area_2d_mouse_entered() -> void:
	$marker/highlight.visible = $marker.visible
	$capture_marker/highlight.visible = $capture_marker.visible
	if position_marker.visible:
		position_marker.play("highlight")

func _on_area_2d_mouse_exited() -> void:
	$marker/highlight.hide()
	$capture_marker/highlight.hide()
	position_marker.stop()

func position_marker_unhighlight():
	for i in position_marker.get_children():
		i.call_deferred("hide")
	position_marker.call_deferred("hide")

func position_marker_light():
	$position_marker/light.show()
	$position_marker/light.play("light")
	
func _on_light_animation_finished() -> void:
	emit_signal("highlight_end")
