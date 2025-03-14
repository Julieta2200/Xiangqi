class_name Dialog extends Control

signal end(dialog)
var dialog

func disappear():
	visible = false

func talk(text: String, name: String):
	dialog = text
	visible = true
	$Panel/RichTextLabel.text = text
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("dialog")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		emit_signal("end",dialog)

	
