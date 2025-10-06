class_name HintBubble extends Control

@onready var hint_label: RichTextLabel = $Panel/Hint
@onready var number_label: Label = $Panel/Number

@export var hint: String = ""
@export var number: String = ""

signal hint_finished()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hint_label.text = hint
	number_label.text = number


func _on_button_pressed() -> void:
	emit_signal("hint_finished")
	hide()
