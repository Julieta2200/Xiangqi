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
			if %Board.state.has(Vector2(6,4)):
				%Board.computer_move(Vector2(6,5), Vector2(6,4))
				return
			
			if !%Board.state.has(Vector2(3,0)):
				%Board.computer_move(Vector2(3,2), Vector2(3,1))
			else:
				%Board.computer_move(Vector2(5,2), Vector2(5,1))
		5:
			if %Board.state.has(Vector2(4,1)):
				if %Board.state.has(Vector2(3,1)):
					%Board.computer_move(Vector2(3,1), Vector2(4,1))
				else:
					%Board.computer_move(Vector2(5,1), Vector2(4,1))
				return
			if %Board.state.has(Vector2(3,1)):
				%Board.computer_move(Vector2(3,1), Vector2(3,0))
			else:
				%Board.computer_move(Vector2(5,1), Vector2(5,0))
			
