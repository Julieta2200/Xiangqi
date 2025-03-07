extends Figure

const directions: Array[Vector2] = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(-1, 0),
		Vector2(1, 0)
	]

func _ready():
	boundaries = {
		Board.team.Red: {
			"y": Vector2(0,9),
			"x": Vector2(0,8)
		},
		Board.team.Black: {
			"y": Vector2(0,9),
			"x": Vector2(0,8)
		},
	}


func get_moves(state: Dictionary, current_position: Vector2) -> Array[Vector2]:
	var moves: Array[Vector2] = []

	for dir in directions:
		var new_pos = current_position + dir
		var have_anchor: bool = false
		while in_boundaries(new_pos):
			if !state.has(new_pos) and !have_anchor:
				moves.append(new_pos)
			elif !have_anchor:
				have_anchor = true
			elif state.has(new_pos):
				if state[new_pos].team != team:
					moves.append(new_pos)
				break
			new_pos += dir
	
	return moves
