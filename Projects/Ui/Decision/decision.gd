extends Control

signal claim
signal set_free


func _on_set_free_pressed() -> void:
	emit_signal("set_free")


func _on_claim_pressed() -> void:
	emit_signal("claim")
