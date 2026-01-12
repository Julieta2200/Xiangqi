extends Node

@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var sounds := {
	"hover_on": preload("res://Assets/Music/SFX and music/UI SFX-Karma Table-BUTTON HOVER OFF.wav"),
	"hover_off": preload("res://Assets/Music/SFX and music/UI SFX-Karma Table-BUTTON HOVER ON.wav"),
	"play_button_select": preload("res://Assets/Music/SFX and music/UI SFX-Overworld-PLAY BUTTON SELECT.wav"),
	"button_select": preload("res://Assets/Music/SFX and music/UI SFX-Overworld-GENERAL SELECT.wav"),
	"dialog_box": preload("res://Assets/Music/SFX and music/UI SFX-Karma Table-DIALOG BOX SHOWN.wav"),
	"ashes_entering_cave": preload("res://Assets/Music/SFX and music/Ashes Entering Cave.wav"),
	"loading_screen_starts": preload("res://Assets/Music/SFX and music/Loading Screen Starts.wav"),
	"opening_panel": preload("res://Assets/Music/SFX and music/Opening Alliance Karma Panel.wav"),
	"closing_panel": preload("res://Assets/Music/SFX and music/Closing Alliance Karma Panel.wav"),
	"back": preload("res://Assets/Music/SFX and music/Pause Menu Open.wav"),
	"strike": preload("res://Assets/Music/SFX and music/Strike Sound.wav"),
}

func _ready() -> void:
	add_child(music_player)

func play_sound(name: String) -> void:
	if sounds.has(name):
		music_player.bus = "SFX"
		music_player.stream = sounds[name]
		music_player.play()

func stop_sound() -> void:
	music_player.stop()
