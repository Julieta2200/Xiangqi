extends Node2D

func _ready():
	var state: Dictionary = {
		Vector2(4, 1): {
			"type": Figure.Types.General,
			"team": Board.team.Red,
			"inactive": true
		},
		Vector2(4,9): {
			"type": Figure.Types.General,
			"team": Board.team.Black
		},
		Vector2(3, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive": true
		},
		Vector2(5, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive": true
		},
		Vector2(3, 9): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Black
		},
		Vector2(5, 9): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Black
		},
		Vector2(4, 3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(5, 2): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(3, 2): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(6, 5): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black
		},
		Vector2(6, 3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
	}
	
	%Board.create_state(state)
	soldier_movement_hint()


func soldier_movement_hint():
	%Hint_system.appear(HintSystem.HINTS.SOLDIER_MOVE)

func check_hint():
	%Hint_system.appear(HintSystem.HINTS.CHECK)
	
func generals_facing_hint():
	%Hint_system.appear(HintSystem.HINTS.GENERALS_FACING)

func computer_move():
	await $tutorial_engine.make_move()
	await get_tree().create_timer(1).timeout 
	match %Board.move_number:
		1:
			%Board.state[Vector2(4,1)].active = true
			check_hint()
		2:
			%Board.state[Vector2(3,0)].active = true
			%Board.state[Vector2(5,0)].active = true
			generals_facing_hint()
		3:
			%Dialog.appear("Your soldier is under attack, but you can attack first.")
		4:
			if %Board.state[Vector2(6,5)] == null:
				%Dialog.appear("You lost your soldier, try again.")
				await get_tree().create_timer(1).timeout
				%Board.load_move(3) 
				return
			
			%Dialog.appear("Your advisor is under attack, move him away from danger.")
		5:
			var advisors: Array[Figure] = %Board.get_figures(Board.team.Red, Figure.Types.Advisor)
			if advisors.size() < 2:
				%Dialog.appear("You lost your advisor, try again.")
				await get_tree().create_timer(1).timeout
				%Board.load_move(4)
			%Dialog.appear("General is under attack, but he can protect himself.")
		6:
			get_tree().change_scene_to_file("res://Projects/puzzles/puzzle1.tscn")
