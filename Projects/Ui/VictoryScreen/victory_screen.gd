extends Control

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

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
