extends Control

signal claim
signal set_free

@onready var card_name: Label = $SetFree/Card_panel/name

func _on_set_free_pressed() -> void:
	emit_signal("set_free")

func _on_claim_pressed() -> void:
	emit_signal("claim")

func set_card_name(name : String) -> void:
	card_name.text = name
	
