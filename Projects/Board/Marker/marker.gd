class_name BoardMarker extends Node2D

enum Highlights {NONE, MOVE, CAPTURE, SPAWN}

var board_position: Vector2i
@onready var walking_marker: Sprite2D = $walking_marker

signal figure_move(marker)
signal figure_set(marker)
signal highlight_end

var state: Highlights

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			match state:
				Highlights.MOVE, Highlights.CAPTURE:
					emit_signal("figure_move",self)
				Highlights.SPAWN:
					emit_signal("figure_set",self)


func highlight(type: Highlights) -> void:
	state = type
	match type:
		Highlights.MOVE:
			$walking_marker/highlight.play("highlight")
			walking_marker.show()
		Highlights.CAPTURE:
			$walking_marker/highlight.play("capture_highlight")
			walking_marker.show()
		
		
func unhighlight():
	state = Highlights.NONE
	$walking_marker.hide()

func _on_area_2d_mouse_entered() -> void:
	$walking_marker/highlight.visible = $walking_marker.visible

func _on_area_2d_mouse_exited() -> void:
	$walking_marker/highlight.hide()
