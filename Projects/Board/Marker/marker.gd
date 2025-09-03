class_name BoardMarker extends Node2D

enum Highlights {NONE, MOVE, CAPTURE, SPAWN, SELECTED}

var board_position: Vector2i
@onready var walking_marker: Sprite2D = $walking_marker
@onready var spawn_marker: AnimatedSprite2D = $spawn_marker

signal figure_move(marker)
signal figure_spawn(marker)
signal spawn_done
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
					$spawn_marker/light.show()
					$spawn_marker/light.play("light")
					emit_signal("figure_spawn",self)


func highlight(type: Highlights) -> void:
	state = type
	match type:
		Highlights.MOVE:
			$walking_marker/highlight.play("highlight")
			walking_marker.show()
		Highlights.CAPTURE:
			$walking_marker/highlight.play("capture_highlight")
			walking_marker.show()
		Highlights.SPAWN:
			spawn_marker.show()
		Highlights.SELECTED:
			$walking_marker/highlight.play("capture_highlight")
			walking_marker.show()
			$walking_marker/highlight.show()
		
		
func unhighlight():
	if state == Highlights.SELECTED:
		$walking_marker/highlight.hide()
	elif state == Highlights.SPAWN:
		$spawn_marker/light.hide()
	state = Highlights.NONE
	spawn_marker.hide()
	walking_marker.hide()

func _on_area_2d_mouse_entered() -> void:
	$walking_marker/highlight.visible = $walking_marker.visible

func _on_area_2d_mouse_exited() -> void:
	if state == Highlights.SELECTED:
		return
	$walking_marker/highlight.hide()

func _on_spawn_light_animation_finished() -> void:
	emit_signal("spawn_done")
