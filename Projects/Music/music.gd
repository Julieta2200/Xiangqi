extends Node2D

@export var music : AudioStreamWAV:
	set(m):
		music = m
		$AudioStreamPlayer.stream = music
