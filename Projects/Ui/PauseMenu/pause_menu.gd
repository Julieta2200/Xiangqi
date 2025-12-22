extends Control

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	$BlurOverlay.material.set_shader_parameter("blur_amount", 2)


func _on_visibility_changed() -> void:
	if audio_player == null:
		return
		
	if visible:
		play_music()
	else:
		audio_player.stop()

func play_music():
	audio_player.volume_db = -20
	audio_player.play()

	var tween:= create_tween()
	tween.tween_property(audio_player, "volume_db", 1, 1)


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_back_to_overworld_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.Overworld)


func _on_back_to_menu_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scenes.MainMenu)
