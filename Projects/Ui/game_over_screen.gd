class_name GameOverScreen extends Control


@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.Overworld)


func _on_visibility_changed() -> void:
	if audio_player == null:
		return
		
	if visible:
		play_music()

func play_music():
	audio_player.volume_db = -20
	audio_player.play()

	var tween:= create_tween()
	tween.tween_property(audio_player, "volume_db", 1, 1)
