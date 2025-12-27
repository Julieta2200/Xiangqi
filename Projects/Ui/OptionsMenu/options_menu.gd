extends Control


@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider

var music_bus_index: int
var sfx_bus_index: int

const music_max_volume: float = 2.0
const sfx_max_volume: float = 2.0
const music_min_volume: float = -30.0
const sfx_min_volume: float = -30.0

# Called when the node enters the scene tree for the first time.
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




func _on_sfx_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, value)
	if value == sfx_min_volume:
		AudioServer.set_bus_mute(sfx_bus_index, true)
	else:
		AudioServer.set_bus_mute(sfx_bus_index, false)

func _on_music_slider_value_changed(value:float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, value)
	if value == music_min_volume:
		AudioServer.set_bus_mute(music_bus_index, true)
	else:
		AudioServer.set_bus_mute(music_bus_index, false)