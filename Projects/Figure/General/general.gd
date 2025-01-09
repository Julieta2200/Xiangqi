extends Figure

func available_moves() -> Array:
	var moves = []

	var palace_min_row = 0
	var palace_max_row = 2
	var palace_min_col = 3
	var palace_max_col = 5

	var directions = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(-1, 0),
		Vector2(1, 0) 
	]

	for dir in directions:
		var new_pos = Vector2(board_position.x, board_position.y) + dir
		if %Board.state[new_pos.x][new_pos.y] == null:
			if new_pos.x >= palace_min_col && new_pos.x <= palace_max_col && new_pos.y >= palace_min_row && new_pos.y <= palace_max_row:
				moves.append(new_pos)

	return moves
