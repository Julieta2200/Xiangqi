extends Node2D

func _ready():
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
			"team": Board.team.Red
		},
		Vector2(4,7): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
		Vector2(5,7): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
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
		},
	}
		
	%Board.create_state(state)

func computer_move():
	await $engine.make_move()
