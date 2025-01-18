extends Node2D

@onready var general_movement_hint_texture = load("res://Assets/tmp/hint_system_ui/generalmove.png")

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
	%Board.calculate_moves()
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
			$GeneralRed.active = true
			check_hint()
		2:
			$AdvisorRed1.active = true
			$AdvisorRed2.active = true
			generals_facing_hint()
		3:
			%Dialog.appear("Move advisor from the danger")
