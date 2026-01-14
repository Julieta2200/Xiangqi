class_name GameOverScreen extends Control


@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var retry_button: Button = $Buttons/Retry
@onready var options_button: Button = $Buttons/Options
@onready var esc_label: Label = $Bottom/Line/EscButton/Esc
@onready var overworld_label: Label = $Bottom/Line/EscButton/Overworld

func _ready() -> void:
	# Set translated text for all menu buttons
	retry_button.text = tr("RETRY")
	options_button.text = tr("OPTIONS")
	esc_label.text = tr("ESC")
	overworld_label.text = tr("OVERWORLD")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit") and visible:
		AudioManager.play_sound("back")
		SceneManager.change_scene(SceneManager.Scenes.Overworld)

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_visibility_changed() -> void:
	if audio_player == null:
		return
		
	if visible:
		AudioManager.play_sound("loading_screen_starts")
		play_music()

func play_music():
	audio_player.volume_db = -20
	audio_player.play()

	var tween:= create_tween()
	tween.tween_property(audio_player, "volume_db", 1, 1)
