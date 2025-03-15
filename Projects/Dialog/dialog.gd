class_name Dialog extends Control

signal finished(to_call: Callable)

var _to_call: Callable

func appear(text: String, to_call: Callable = func():):
	visible = true
	_to_call = to_call
	$Panel/RichTextLabel.text = text
	$AnimationPlayer.play("dialog")

func disappear():
	visible = false
	$AnimationPlayer.play("RESET")

func next():
	disappear()
	emit_signal("finished", _to_call)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next"):
		next()
