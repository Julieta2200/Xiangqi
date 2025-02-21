extends Node2D

signal create_static_figures(state :Dictionary)

func _ready() -> void:
	var state: Dictionary = {
		Vector2(3,0): {
			"type": Figure.Types.General,
			"team": Board.team.Red
		},
		Vector2(4,1): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red
		},
		Vector2(5,0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red
		},
		Vector2(3,7): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(4,7): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(4,9): {
			"type": Figure.Types.General,
			"team": Board.team.Black
		},
		Vector2(5,9): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Black
		},
		Vector2(3,9): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Black
		}
	}
	
	emit_signal("create_static_figures", state)


func _on_board_editor_start(state: Dictionary) -> void:
	%Board.create_state(state)
	$BoardEditor.hide()
	$gameplay.show()
