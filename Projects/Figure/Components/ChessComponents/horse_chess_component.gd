extends ChessComponent

const directions: Array[Dictionary] = [
		{ "move": Vector2i(-2, -1), "blocker": Vector2i(-1, 0) },
		{ "move": Vector2i(-2, 1), "blocker": Vector2i(-1, 0) },
		{ "move": Vector2i(2, -1), "blocker": Vector2i(1, 0) },
		{ "move": Vector2i(2, 1), "blocker": Vector2i(1, 0) },
		{ "move": Vector2i(-1, -2), "blocker": Vector2i(0, -1) },
		{ "move": Vector2i(1, -2), "blocker": Vector2i(0, -1) },
		{ "move": Vector2i(-1, 2), "blocker": Vector2i(0, 1) },
		{ "move": Vector2i(1, 2), "blocker": Vector2i(0, 1) }
	]

func _ready() -> void:
	super._ready()
	boundaries = {
		BoardV2.Teams.Red: {
			"y": Vector2i(0, 9),
			"x": Vector2i(0, 8)
		},
		BoardV2.Teams.Black: {
			"y": Vector2i(0, 9),
			"x": Vector2i(0, 8)
		}
	}
				
func calculate_moves(state: Dictionary, current_position: Vector2i) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	
	for dir in directions:
		var new_pos = current_position + dir.move
		var blocker_pos = dir.blocker
		if in_boundaries(new_pos) and free_path(current_position, blocker_pos, state) and move_or_capture(new_pos, state):       
			moves.append(new_pos)
	
	return moves
	
func free_path(current_position: Vector2i, dir: Vector2i, state: Dictionary) -> bool:
	return !state.has(current_position + dir)
