extends ChessComponent

const directions: Array[Vector2i] = [
		Vector2i(-2, -2),
		Vector2i(2, -2),
		Vector2i(-2, 2),
		Vector2i(2, 2)
	]

func _ready() -> void:
	super._ready()
	boundaries = {
		Board.team.Red: {
			"y": Vector2i(0,4),
			"x": Vector2i(0,8)
		},
		Board.team.Black: {
			"y": Vector2i(5,9),
			"x": Vector2i(0,8)
		},
	}
				
func calculate_moves(state: Dictionary, current_position: Vector2i) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) and free_path(current_position, dir/2, state) and move_or_capture(new_pos, state):
			moves.append(new_pos)
	
	return moves

func free_path(current_position: Vector2i, dir: Vector2i, state: Dictionary) -> bool:
	return !state.has(current_position+dir)
