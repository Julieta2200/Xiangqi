extends ComputerEngine

var capture_figure: bool
var general_moving: bool

func make_move() -> void:
	match %Board.move_number:
		1:
			next_position(Vector2(4,7))
		2:
			next_position(Vector2(4,6))
		3:
			next_position(Vector2(4,5))
		4:
			next_position(Vector2(4,4))
			next_position(Vector2(2,5))
		5:
			next_position(Vector2(2,4))
		6:
			next_position(Vector2(2,3))
		7:
			next_position(Vector2(2,2))
		8:
			next_position(Vector2(2,1))
		10:
			if %Board.state.has(Vector2(5, 0)):
				next_position(Vector2(3, 2))
			else:
				next_position(Vector2(5, 2))
		
		11:
			if %Board.state.has(Vector2(5, 0)):
				if %Board.state.has(Vector2(5, 1)):
					next_position(Vector2(5, 1))
				elif %Board.state.has(Vector2(3, 2)):
					next_position(Vector2(5, 2))
				else:
					next_position(Vector2(3, 1))
			else:
				if %Board.state.has(Vector2(3, 1)):
					next_position(Vector2(3, 1))
				elif %Board.state.has(Vector2(5, 2)):
					next_position(Vector2(3, 2))
				else:
					next_position(Vector2(5, 1))
		12:
			if %Board.state.has(Vector2(3, 0)) and %Board.state[Vector2(3, 0)].type == Figure.Types.Soldier:
				next_position(Vector2(3, 0), Vector2(1, 0))
			elif %Board.state.has(Vector2(5, 0)) and %Board.state[Vector2(5, 0)].type == Figure.Types.Soldier:
				next_position(Vector2(5, 0), Vector2(-1, 0))
			elif %Board.state.has(Vector2(5, 0)):
				next_position(Vector2(5, 1))
			elif  %Board.state.has(Vector2(3, 0)):
				next_position(Vector2(3, 1))
			else:
				next_position(Vector2(5, 1), Vector2(-1, 0))


func next_position(pos, direction = Vector2(0,-1)):
	var new_pos = pos + direction
	capture_figure = %Board.state.has(new_pos)
	%Board.computer_move(pos, new_pos)
