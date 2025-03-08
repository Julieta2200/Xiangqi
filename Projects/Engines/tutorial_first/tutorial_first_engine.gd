extends ComputerEngine

func make_move() -> void:
	match %Board.move_number:
		1:
			%Board.computer_move(Vector2(4,6), Vector2(4,5))
		2:
			%Board.computer_move(Vector2(4,5), Vector2(4,4))
		3:
			%Board.computer_move(Vector2(4,4), Vector2(4,3))
		4:
			%Board.computer_move(Vector2(4,3), Vector2(4,2))
