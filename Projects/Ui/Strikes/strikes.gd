class_name Strikes extends Control

@onready var strikes: Array[TextureRect] = [
	$HBoxContainer/Strike1,
	$HBoxContainer/Strike2,
	$HBoxContainer/Strike3,
]

var strike: int = 3

func apply_strike() -> void:
	await get_tree().process_frame
	strike -= 1
	if strike < 0:
		return
	strikes[strike].modulate = Color(1, 1, 1, 0.4)
