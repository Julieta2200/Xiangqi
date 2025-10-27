extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var sounds := {
	"play_button_select": preload("res://Assets/Music/overworld/UI SFX-Overworld-PLAY BUTTON SELECT.wav"),
	"button_select": preload("res://Assets/Music/overworld/UI SFX-Overworld-GENERAL SELECT.wav")
}

func _ready() -> void:
	add_child(music_player)
	#music_player.autoplay = false
	#music_player.bus = "Master"

func play_sound(name: String) -> void:
	if sounds.has(name):
		music_player.stream = sounds[name]
		music_player.play()

func stop_sound() -> void:
	music_player.stop()
