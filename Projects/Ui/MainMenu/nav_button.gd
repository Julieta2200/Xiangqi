extends Button


func _on_mouse_entered() -> void:
	AudioManager.play_sound("hover_on")


func _on_pressed() -> void:
	AudioManager.play_sound("button_select")
