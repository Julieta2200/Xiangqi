extends ComputerEngine

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
		5:
			next_position(Vector2(4,3))
		#4:
			#next_position(Vector2(2,5))
		#5:
			#next_position(Vector2(2,4))
		#6:
			#next_position(Vector2(2,3))
		#7:
			#next_position(Vector2(2,2))
		#8:
			#next_position(Vector2(2,1))
				

func next_position(pos):
	var new_pos = pos - Vector2(0,1)
	%Board.computer_move(pos, new_pos)
