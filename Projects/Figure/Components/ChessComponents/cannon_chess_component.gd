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
		var new_pos = current_position + dir
		var have_anchor: bool = false
		while in_boundaries(new_pos):
			if !state.has(new_pos) and !have_anchor:
				moves.append(new_pos)
			elif !have_anchor:
				have_anchor = true
			elif state.has(new_pos):
				if state[new_pos].chess_component.team != team:
					moves.append(new_pos)
				break
			new_pos += dir
	
	return moves
