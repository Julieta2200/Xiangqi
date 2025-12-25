class_name Option extends Button

func _on_mouse_entered() -> void:
	text = "> " + text

func _on_mouse_exited() -> void:
	text = text.replace("> ", "")
