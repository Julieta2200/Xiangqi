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
		while in_boundaries(new_pos):
			if !state.has(new_pos):
				moves.append(new_pos)
			else:
				if state[new_pos].team != team:
					moves.append(new_pos)
				break
			new_pos += dir
	
	return moves

func mobility_factor(state: Dictionary, current_position: Vector2) -> float:
	var factor: float
	var moves: Array[Vector2] = get_moves(state, current_position)
	factor = float(moves.size())/17.0
	
	return factor
