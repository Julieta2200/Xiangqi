class_name Dialog extends Control

# Emitted when the texts are finished, passing the callable to execute next
signal finished(to_call: Callable)

# Saves figures images with their respective names
var figures: Dictionary = {
	"Ashes": load("res://Assets/Characters/Magma/General/Sides/Ashes_front.png"),
	"Advisor": load("res://Assets/Characters/Magma/Advisor/Advisor_front.png"),
	"Pawn" : load("res://Assets/Characters/Cloud/Pawn/Idle/Front idle/Front1.png"),
	"Cloud General" : load("res://Assets/Characters/Cloud/General/General_front.png")
}


@export var typing_speed = 0.03
var tween : Tween

var _to_call: Callable
var _text_blocks: Array[TextBlock]

func typing_animation(text):
	$Panel/Text.visible_ratio = 0
	if tween != null:
		tween.stop()
	tween = create_tween()
	tween.tween_property($Panel/Text, "visible_ratio", 1, text.length() * typing_speed) 

func appear(text_blocks: Array[TextBlock], to_call: Callable = func():):
	visible = true
	_to_call = to_call
	var text_block: TextBlock = text_blocks.pop_front()
	_text_blocks = text_blocks
	$Panel/Text.text = text_block.text
	$Panel/Name.text = text_block.name
	$Panel/image.texture_progress = figures[text_block.name]
	typing_animation(text_block.text)

func disappear():
	visible = false

# Handles transition to the next text block or emits a signal if all blocks have been displayed
func next():
	disappear()
	if _text_blocks.size() == 0:
		emit_signal("finished", _to_call)
	else:
		appear(_text_blocks, _to_call)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("next"):
		next()
