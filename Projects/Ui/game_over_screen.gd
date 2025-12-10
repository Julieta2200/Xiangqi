class_name GameOverScreen extends Control



func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.Overworld)