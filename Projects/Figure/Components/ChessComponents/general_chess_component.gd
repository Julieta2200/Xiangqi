extends ChessComponent

const directions: Array[Vector2i] = [
		Vector2i(0, 1),
		Vector2i(0, -1),
		Vector2i(-1, 0),
		Vector2i(1, 0)
	]

func _ready() -> void:
	super._ready()
	boundaries = {
		BoardV2.Teams.Red: {
			"y": Vector2i(0,2),
			"x": Vector2i(3,5)
		},
		BoardV2.Teams.Black: {
			"y": Vector2i(7,9),
			"x": Vector2i(3,5)
		},
	}
	
func calculate_moves(state: Dictionary, current_position: Vector2i) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	
	for dir in directions:
		var new_pos = position + dir
		if in_boundaries(new_pos) and move_or_capture(new_pos,state):
			moves.append(new_pos)
	
	return moves
