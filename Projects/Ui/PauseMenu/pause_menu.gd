extends Control

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var restart_button: Button = $Navigation/Restart
@onready var back_to_overworld_button: Button = $"Navigation/Back to Overworld"
@onready var back_to_menu_button: Button = $"Navigation/Back to Menu"
@onready var options_button: Button = $Navigation/Options
@onready var esc_label: Label = $Bottom/Line/EscButton/Esc
@onready var resume_label: Label = $Bottom/Line/EscButton/Resume



func _ready() -> void:
	$BlurOverlay.material.set_shader_parameter("blur_amount", 2)
	
	# Set translated text for all menu buttons
	restart_button.text = tr("RESTART")
	options_button.text = tr("OPTIONS")
	back_to_overworld_button.text = tr("BACK_TO_OVERWOLD")
	back_to_menu_button.text = tr("BACK_TO_MENU")
	esc_label.text = tr("ESC")
	resume_label.text = tr("RESUME")


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
