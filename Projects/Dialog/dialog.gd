class_name Dialog extends Control

func appear(text: String):
	visible = true
	$Panel/RichTextLabel.text = text
	$AnimationPlayer.play("dialog")


func disappear():
	visible = false





