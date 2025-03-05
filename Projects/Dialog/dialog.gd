class_name Dialog extends Control

func appear(text: String, time: float = 0):
	visible = true
	$Panel/RichTextLabel.text = text
	$AnimationPlayer.play("dialog")
	if time != 0:
		$Timer.start()

func disappear():
	visible = false


func _on_timer_timeout() -> void:
	disappear()
