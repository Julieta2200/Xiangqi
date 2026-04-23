extends Control

const YELLOW := Color(0.984314, 0.760784, 0.211765, 1)
const WHITE := Color(1, 1, 1, 1)

@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var language: Label = %Language
@onready var language_buttons: HBoxContainer = %Language.get_node("HBoxContainer")

var music_bus_index: int
var sfx_bus_index: int

const music_max_volume: float = 2.0
const sfx_max_volume: float = 2.0
const music_min_volume: float = -30.0
const sfx_min_volume: float = -30.0

func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	var music_volume = AudioServer.get_bus_volume_db(music_bus_index)
	var sfx_volume = AudioServer.get_bus_volume_db(sfx_bus_index)
	music_slider.value = music_volume
	sfx_slider.value = sfx_volume
	music_slider.max_value = music_max_volume
	sfx_slider.max_value = sfx_max_volume
	music_slider.min_value = music_min_volume
	sfx_slider.min_value = sfx_min_volume
	_update_language_buttons(TranslationServer.get_locale())




func _on_sfx_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, value)
	if value == sfx_min_volume:
		AudioServer.set_bus_mute(sfx_bus_index, true)
	else:
		AudioServer.set_bus_mute(sfx_bus_index, false)
	GameState.config["sfx_volume"] = value
	GameState.save_config()

func _on_music_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, value)
	if value == music_min_volume:
		AudioServer.set_bus_mute(music_bus_index, true)
	else:
		AudioServer.set_bus_mute(music_bus_index, false)
	GameState.config["music_volume"] = value
	GameState.save_config()

func set_language(locale: String) -> void:
	TranslationServer.set_locale(locale)
	GameState.config["language"] = locale
	GameState.save_config()
	_update_language_buttons(locale)

func _update_language_buttons(locale: String) -> void:
	var locale_map := {
		"en": "EnglishButton",
		"zh": "ChineseButton",
		"de": "GermanButton",
		"es": "SpanishButton",
		"fr": "FrenchButton",
		"it": "ItalianButton",
	}
	for button in language_buttons.get_children():
		var is_active: bool = locale_map.get(locale, "") == button.name
		button.add_theme_color_override("font_color", YELLOW if is_active else WHITE)
