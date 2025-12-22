extends Node2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


@export var music : AudioStreamWAV:
	set(m):
		music = m
		$AudioStreamPlayer.stream = music
