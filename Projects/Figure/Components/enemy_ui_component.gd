extends FigureUIComponent


func _on_mouse_entered() -> void:
	mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
