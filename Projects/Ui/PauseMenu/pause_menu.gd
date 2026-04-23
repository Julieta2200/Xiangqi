extends Control

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var resume_label: Label = $Bottom/Line/EscButton/Resume
@onready var options_menu: Control = %OptionsMenu
@onready var navigation: VBoxContainer = %Navigation

enum States {None, Options}
var state: States

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


func _on_options_pressed() -> void:
	navigation.hide()
	options_menu.show()
	state = States.Options
	resume_label.text = tr("BACK")

func options_back() -> void:
	navigation.show()
	options_menu.hide()
	state = States.None
	resume_label.text = tr("RESUME")
