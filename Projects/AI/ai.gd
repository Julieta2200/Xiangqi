class_name AI extends Node

@export var board: BoardV2

func _ready() -> void:
	randomize()

func get_figures() -> Array[FigureComponent]:
	return board.get_figures(BoardV2.Teams.Black)
	
func make_move() -> bool:
	select_best_move(3)
	return true

func evaluate_position(state: Dictionary, team: BoardV2.Teams) -> int:
	var score: int = 0
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team == team:
			score += figure.chess_component.value
		else:
			score -= figure.chess_component.value
	return score

func duplicate_state(state: Dictionary) -> Dictionary:
	var d: Dictionary
	for pos in state:
		d[pos] = state[pos]
	return d

func simulate_move(state: Dictionary, move: Dictionary) -> Dictionary:
	var new_state: Dictionary = duplicate_state(state)
	new_state[move["end"]] = new_state[move["start"]]
	new_state.erase(move["start"])
	return new_state

func minimax(state: Dictionary, depth: int, maximizingPlayer: bool, alpha: int, beta: int) -> int:
	if depth == 0:
		return evaluate_position(state, BoardV2.Teams.Black)
	
	if maximizingPlayer:
		var maxEval = -INF
		for move in get_all_legal_moves(BoardV2.Teams.Black, state):
			var new_board = simulate_move(state, move)
			var eval = minimax(new_board, depth - 1, false, alpha, beta)
			maxEval = max(maxEval, eval)
			alpha = max(alpha, eval)
			if beta <= alpha:
				break
		return maxEval
	else:
		var minEval = INF
		for move in get_all_legal_moves(BoardV2.Teams.Red, state):
			var new_board = simulate_move(state, move)
			var eval = minimax(new_board, depth - 1, true, alpha, beta)
			minEval = min(minEval, eval)
			beta = min(beta, eval)
			if beta <= alpha:
				break
		return minEval

func get_all_legal_moves(team: BoardV2.Teams, state: Dictionary) -> Array[Dictionary]:
	var legal_moves: Array[Dictionary] = []
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team != team:
			continue
		var moves: Array[Vector2i] = figure.chess_component.calculate_moves(state, pos)
		for move in moves:
			legal_moves.append({
				"start": pos,
				"end": move
			})
		
	return legal_moves

func select_best_move(depth: int) -> void:
	var best_score = -INF
	var best_move = null
	var moves = get_all_legal_moves(BoardV2.Teams.Black, board.state)
	for move in moves:
		var new_board = simulate_move(board.state, move)
		var score = minimax(new_board, depth - 1, false, -INF, INF)
		if score > best_score:
			best_score = score
			best_move = move
	if best_move:
		board.move_figure_AI(best_move)
