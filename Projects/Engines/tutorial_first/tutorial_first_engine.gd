extends ComputerEngine

func make_move() -> void:
	await get_tree().create_timer(0.3).timeout 
	%Board.turn = Board.team.Red
		
