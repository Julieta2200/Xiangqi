class_name HintSystem extends Control

enum HINTS {SOLDIER_MOVE, CHECK, GENERAL_MOVE, GENERALS_FACING, ADVISOR_MOVE}

var active_hint: HINTS

@onready var hints: Dictionary = {
	HINTS.SOLDIER_MOVE: {
		"texture": load("res://Assets/tmp/hint_system_ui/soldier_move.png"),
		"text": "Soldiers move and capture by advancing one point forward. Once a pawn has crossed the river it may also move and capture one point horizontally. A pawn may never move backward, thus retreating.",
		"dialog_text": "Click on soldier and make him move."
	},
	HINTS.CHECK: {
		"texture": load("res://Assets/tmp/hint_system_ui/check.png"),
		"text": "General is under attack (check), it's mandatory to move out of check.",
		"next_hint": HINTS.GENERAL_MOVE
	},
	HINTS.GENERAL_MOVE: {
		"texture": load("res://Assets/tmp/hint_system_ui/general_move.png"),
		"text": "Generals may move one point either vertically or horizontally, but not diagonally and is confined to the nine points within his palace. ",
		"dialog_text": "Move general out of check.",
	},
	HINTS.GENERALS_FACING: {
		"texture": load("res://Assets/tmp/hint_system_ui/ganeral_facing.png"),
		"text": "A general may not also move into a file, which is occupied by the enemy general, unless there is at least one piece positioned between the generals in the file",
		"next_hint": HINTS.ADVISOR_MOVE,
	},
	HINTS.ADVISOR_MOVE: {
		"texture": load("res://Assets/tmp/hint_system_ui/advisor_move.png"),
		"text": "These are the king’s counselors and guard the king within the palace. The guard moves one point diagonally and is confined to the palace.",
		"dialog_text": "Use one of the advisors to save the general.",
	}
}

func appear(hint: HINTS):
	visible = true
	active_hint = hint
	$Background/Hint_texture.texture = hints[hint].texture
	$Background/RichTextLabel.text = hints[hint].text
	$Background/AnimationPlayer.play("write_text")


func _on_ok_button_pressed():
	visible = false
	if hints[active_hint].has("next_hint"):
		appear(hints[active_hint].next_hint)
	else:
		%Dialog.appear(hints[active_hint].dialog_text)
