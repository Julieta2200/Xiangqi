class_name Evaluation extends Node2D

var best_move: Dictionary

func evaluate(state: Dictionary, turn: Board.team, depth: int) -> float:
	var evaluation: float
	var best_moves: Array[Dictionary] = []
	
	for pos in state:
		if state[pos] != null and state[pos].team == turn:
			var moves: Array[Vector2] = state[pos].get_moves(state, pos)
			for m in moves:
				var tmp_state: Dictionary = state.duplicate()
				tmp_state[m] = tmp_state[pos]
				tmp_state[pos] = null
				if depth == 0:
					best_moves.append({
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation": evaluate_single_state(tmp_state)
					})
				else:
					best_moves.append({
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation": evaluate(tmp_state, next_turn(turn), depth - 1)
					})
	
	var result: float = best_moves[0].evaluation
	best_move = best_moves[0].move
	for bm in best_moves:
		if turn == Board.team.Red:
			if result < bm.evaluation:
				result = bm.evaluation
				best_move = bm.move
		else:
			if result > bm.evaluation:
				result = bm.evaluation
				best_move = bm.move
	
	return result

func evaluate_single_state (state: Dictionary) -> float:
	var evaluation: float
	for pos in state:
		if state[pos] != null:
			if state[pos].team == Board.team.Red:
				evaluation += state[pos].value
			else:
				evaluation -= state[pos].value
	return evaluation

func next_turn(turn: Board.team) -> Board.team:
	if turn == Board.team.Red:
		return Board.team.Black
	return Board.team.Red
