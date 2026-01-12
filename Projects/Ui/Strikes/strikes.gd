class_name Strikes extends Control

@onready var strikes: Array[TextureRect] = [
	$HBoxContainer/Strike1,
	$HBoxContainer/Strike2,
	$HBoxContainer/Strike3,
]

@onready var strike_used_sprite: CompressedTexture2D = preload("res://Assets/UI/Strike/icon(red).png")

var strike: int = 3

func apply_strike() -> void:
	await get_tree().process_frame
	strike -= 1
	if strike < 0:
		return
	strikes[strike].texture = strike_used_sprite
	AudioManager.play_sound("strike")
