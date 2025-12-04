extends CanvasLayer


func _on_level_1_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.Level_1)


func _on_level_2_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.Level_2)


func _on_level_3_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.Level_3)
