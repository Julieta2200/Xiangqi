extends ChessComponent

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
	
	var directions = []
	match team:
		BoardV2.Teams.Red:
			directions.append(Vector2i(0, 1))
			if current_position.y >= 5:
				directions += [Vector2i.LEFT, Vector2i.RIGHT]
		BoardV2.Teams.Black:
			directions.append(Vector2i(0, -1))
			if current_position.y <= 4:
				directions += [Vector2i.LEFT, Vector2i.RIGHT]
	
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) && move_or_capture(new_pos, state):
			moves.append(new_pos)
	
	return moves
