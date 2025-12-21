class_name HintSystem extends Control

enum HINTS {SOLDIER_MOVE, CHECK, GENERAL_MOVE, GENERALS_FACING, ADVISOR_MOVE}

var active_hint: HINTS

@onready var hints: Dictionary = {
	HINTS.SOLDIER_MOVE: {
		"texture": load("res://Assets/tmp/hint_system_ui/soldier_move.png"),
		"text": "HINT_SOLDIER_MOVE_TEXT",
		"dialog_text": "HINT_SOLDIER_MOVE_DIALOG"
	},
	HINTS.CHECK: {
		"texture": load("res://Assets/tmp/hint_system_ui/check.png"),
		"text": "HINT_CHECK_TEXT",
		"next_hint": HINTS.GENERAL_MOVE
	},
	HINTS.GENERAL_MOVE: {
		"texture": load("res://Assets/tmp/hint_system_ui/general_move.png"),
		"text": "HINT_GENERAL_MOVE_TEXT",
		"dialog_text": "HINT_GENERAL_MOVE_DIALOG",
	},
	HINTS.GENERALS_FACING: {
		"texture": load("res://Assets/tmp/hint_system_ui/ganeral_facing.png"),
		"text": "HINT_GENERALS_FACING_TEXT",
		"next_hint": HINTS.ADVISOR_MOVE,
	},
	HINTS.ADVISOR_MOVE: {
		"texture": load("res://Assets/tmp/hint_system_ui/advisor_move.png"),
		"text": "HINT_ADVISOR_MOVE_TEXT",
		"dialog_text": "HINT_ADVISOR_MOVE_DIALOG",
	}
}

func appear(hint: HINTS):
	visible = true
	active_hint = hint
	$Background/Hint_texture.texture = hints[hint].texture
	$Background/RichTextLabel.text = tr(hints[hint].text)
	$Background/AnimationPlayer.play("write_text")


func _on_ok_button_pressed():
	visible = false
	if hints[active_hint].has("next_hint"):
		appear(hints[active_hint].next_hint)
	else:
		var dialog_text_key = hints[active_hint].dialog_text
		var translated_text = tr(dialog_text_key)
		%Dialog.appear([TextBlock.new(translated_text, "Advisor", "Sprite")])
