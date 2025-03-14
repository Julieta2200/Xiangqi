class_name Dialog extends Control

func appear(text: String):
	$Panel/RichTextLabel.text = text
	text_play()

func disappear():
	visible = false

func talk(text: String, name: String):
	$Panel/RichTextLabel.text = text
	text_play()

func text_play():
	visible = true
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("dialog")
