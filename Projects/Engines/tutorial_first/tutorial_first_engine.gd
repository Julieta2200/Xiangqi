extends ComputerEngine

func make_move() -> void:
	await get_tree().create_timer(0.3).timeout 
	match %Board.move_number:
		1:
			%Board.turn = Board.team.Red
		2:
			%Board.turn = Board.team.Red
