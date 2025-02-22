extends Figure

const directions: Array[Vector2] = [
		Vector2(-2, -2),
		Vector2(2, -2),
		Vector2(-2, 2),
		Vector2(2, 2)
	]

func _ready():
	boundaries = {
		Board.team.Red: {
			"y": Vector2(0,4),
			"x": Vector2(0,8)
		},
		Board.team.Black: {
			"y": Vector2(5,9),
			"x": Vector2(0,8)
		},
	}
				
func get_moves(state: Dictionary, current_position: Vector2) -> Array[Vector2]:
	var moves: Array[Vector2] = []
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) and free_path(current_position, dir/2, state) and move_or_capture(new_pos, state):
			if board.valid_future_state(current_position, new_pos, state):
				moves.append(new_pos)
	
	return moves

func free_path(current_position: Vector2, dir: Vector2, state: Dictionary) -> bool:
	return !state.has(current_position+dir)
