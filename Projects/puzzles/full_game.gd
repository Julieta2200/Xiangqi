extends Node2D

var figure_count: int

func _ready():
	var state: Dictionary = {
		# Red
		Vector2(0,0): {
			"type": Figure.Types.Chariot,
			"team": Board.team.Red
		},
		Vector2(8,0): {
			"type": Figure.Types.Chariot,
			"team": Board.team.Red
		},
		Vector2(1,0): {
			"type": Figure.Types.Horse,
			"team": Board.team.Red
		},
		Vector2(7,0): {
			"type": Figure.Types.Horse,
			"team": Board.team.Red
		},
		Vector2(2,0): {
			"type": Figure.Types.Elephant,
			"team": Board.team.Red
		},
		Vector2(6,0): {
			"type": Figure.Types.Elephant,
			"team": Board.team.Red
		},
		Vector2(3,0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red
		},
		Vector2(5,0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red
		},
		Vector2(4,0): {
			"type": Figure.Types.General,
			"team": Board.team.Red
		},
		Vector2(1, 2): {
			"type": Figure.Types.Cannon,
			"team": Board.team.Red
		},
		Vector2(7, 2): {
			"type": Figure.Types.Cannon,
			"team": Board.team.Red
		},
		Vector2(0,3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
		Vector2(2,3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
		Vector2(4,3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
		Vector2(6,3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
		Vector2(8,3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
		# black
		Vector2(0,9): {
			"type": Figure.Types.Chariot,
			"team": Board.team.Black
		},
		Vector2(8,9): {
			"type": Figure.Types.Chariot,
			"team": Board.team.Black
		},
		Vector2(1,9): {
			"type": Figure.Types.Horse,
			"team": Board.team.Black
		},
		Vector2(7,9): {
			"type": Figure.Types.Horse,
			"team": Board.team.Black
		},
		Vector2(2,9): {
			"type": Figure.Types.Elephant,
			"team": Board.team.Black
		},
		Vector2(6,9): {
			"type": Figure.Types.Elephant,
			"team": Board.team.Black
		},
		Vector2(3,9): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Black
		},
		Vector2(5,9): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Black
		},
		Vector2(4,9): {
			"type": Figure.Types.General,
			"team": Board.team.Black
		},
		Vector2(1, 7): {
			"type": Figure.Types.Cannon,
			"team": Board.team.Black
		},
		Vector2(7, 7): {
			"type": Figure.Types.Cannon,
			"team": Board.team.Black
		},
		Vector2(0,6): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(2,6): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(4,6): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(6,6): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(8,6): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
	}
	
	%Board.create_state(state)

func computer_move():
	await $engine.make_move()
	var fc = %Board.get_figures_by_team(Board.team.Red).size()
