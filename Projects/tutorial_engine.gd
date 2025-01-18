extends ComputerEngine

func make_move() -> void:
	await get_tree().create_timer(1).timeout 
	match %Board.move_number:
		1:
			%Board.computer_move(Vector2(4,3), Vector2(4,2))
		2:
			%Board.computer_move(Vector2(4,2), Vector2(4,1))
		3:
			%Board.computer_move(Vector2(3,9), Vector2(4,8))
		4:
			if %Board.state[Vector2(3,0)] == null:
				%Board.computer_move(Vector2(3,2), Vector2(3,1))
			else:
				%Board.computer_move(Vector2(5,2), Vector2(5,1))
				
