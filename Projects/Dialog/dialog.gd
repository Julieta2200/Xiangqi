class_name Dialog extends Control

signal finished(to_call: Callable)

var _to_call: Callable
var _text_blocks: Array[TextBlock]

func appear(text_blocks: Array[TextBlock], to_call: Callable = func():):
	visible = true
	_to_call = to_call
	var text_block: TextBlock = text_blocks.pop_front()
	_text_blocks = text_blocks
	$Panel/RichTextLabel.text = text_block.text
	$AnimationPlayer.play("dialog")

func disappear():
	visible = false
	$AnimationPlayer.play("RESET")

func next():
	disappear()
	if _text_blocks.size() == 0:
		emit_signal("finished", _to_call)
	else:
		appear(_text_blocks, _to_call)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next"):
		next()
