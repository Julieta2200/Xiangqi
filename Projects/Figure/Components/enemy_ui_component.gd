extends FigureUIComponent


func _on_mouse_entered() -> void:
	mouse_in = true
	super._on_mouse_entered()


func _on_mouse_exited() -> void:
	mouse_in = false
	super._on_mouse_exited()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass
