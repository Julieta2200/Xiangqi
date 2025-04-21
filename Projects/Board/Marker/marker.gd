class_name BoardMarker extends Node2D

var board_position: Vector2
@onready var position_marker: AnimatedSprite2D = $position_marker
@onready var walking_marker: Sprite2D = $walking_marker
@onready var horizontal_line: Sprite2D = $position_marker/horizontal_line
@onready var vertical_line: Sprite2D = $position_marker/vertical_line

signal figure_move(marker)
signal figure_set(marker)
signal highlight_end

var can_click: bool = true

func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") and can_click:
		if walking_marker.visible:
			emit_signal("figure_move",self)
		elif position_marker.visible:
			emit_signal("figure_set",self)


func highlight(busy: bool = false):
	if !busy:
		$walking_marker/highlight.play("highlight")
	else:
		$walking_marker/highlight.play("capture_highlight")
	walking_marker.show()
		
func unhighlight():
	$walking_marker.hide()
	position_marker.stop()

func _on_area_2d_mouse_entered() -> void:
	$walking_marker/highlight.visible = $walking_marker.visible
	if can_click:
		position_marker.play("highlight")

func _on_area_2d_mouse_exited() -> void:
	$walking_marker/highlight.hide()
	position_marker.stop()

func position_marker_unhighlight():
	var tween = create_tween()
	tween.tween_property(position_marker, "modulate:a", 0.0, 1) 
	tween.finished.connect(_hide_position_marker)

func _hide_position_marker():
	for i in position_marker.get_children():
		i.hide()
	position_marker.hide()
	position_marker.animation = "highlight"
	position_marker.modulate = Color(1, 1, 1, 1)
	can_click = true

func position_marker_light(group):
	if group != "Magma":
		position_marker.show()
	can_click = false
	position_marker.play(group + "_hover")
	$position_marker/light.show()
	$position_marker/light.play(group + "_light")
	
func _on_light_animation_finished() -> void:
	emit_signal("highlight_end")
	$position_marker/light.call_deferred("hide")
	
