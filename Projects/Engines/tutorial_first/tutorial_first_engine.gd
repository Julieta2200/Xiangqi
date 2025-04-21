extends ComputerEngine

func make_move() -> void:
	match $"..".part:
		1:
			match %Board.move_number:
				1:
					next_position(Vector2(4,7))
				2:
					next_position(Vector2(4,6))
				3:
					next_position(Vector2(4,5))
				4:
					next_position(Vector2(4,4))
				5:
					next_position(Vector2(4,3))
		2:
			match %Board.move_number:
				1:
					next_position(Vector2(2,5))
				2:
					next_position(Vector2(2,4))
				3:
					next_position(Vector2(2,3))
				4:
					next_position(Vector2(2,2))
				5:
					next_position(Vector2(2,1))
				

func next_position(pos):
	var new_pos = pos - Vector2(0,1)
	%Board.computer_move(pos, new_pos)
