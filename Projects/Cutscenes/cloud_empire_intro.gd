extends Node2D

@onready var board: Board = %Board

var initial_state = {
		Vector2(4, 2): {
			"type": Figure.Types.General,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
		Vector2(3, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
		Vector2(5, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
	}

func _ready() -> void:
	%Board.create_state(initial_state)
