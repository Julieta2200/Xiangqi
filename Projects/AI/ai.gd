class_name AI extends Node

@export var board: BoardV2

const infinite : int = 500000
var thinking_thread: Thread = Thread.new()


func _ready() -> void:
	randomize()


func get_figures() -> Array[FigureComponent]:
	return board.get_figures(BoardV2.Teams.Black)
	
func make_move() -> bool:
	thinking_thread.start(select_best_move.bind(3))
	return true

func evaluate_position(state: Dictionary, team: BoardV2.Teams) -> int:
	var red_general: bool
	var black_general: bool
	var score: int = 0
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team == team:
			score += figure.chess_component.value
			score += get_aggression_bonus(pos, state)
			score += get_mobility_bonus(pos, state)
			if figure.type == FigureComponent.Types.GENERAL:
				black_general = true
		elif figure.chess_component.team != BoardV2.Teams.Wall:
			score -= figure.chess_component.value
			score -= get_aggression_bonus(pos, state)
			score -= get_mobility_bonus(pos, state)
			if figure.type == FigureComponent.Types.GENERAL:
				red_general = true
	if !red_general:
		return infinite-1
	
	if !black_general:
		return -infinite+1
	
	return score

func get_aggression_bonus(pos: Vector2i, state: Dictionary) -> int:
	var bonus: int = 0
	
	# Encourage advancing soldiers
	if state[pos].type == FigureComponent.Types.SOLDIER:
		match state[pos].chess_component.team:
			BoardV2.Teams.Red:
				if state[pos].chess_component.position.y >= 5:
					bonus += 10
			BoardV2.Teams.Black:
				if state[pos].chess_component.position.y <= 4:
					bonus += 10
	
	# Encourage pieces near enemy palace
	if board.palace_positions.has(pos):
		match state[pos].chess_component.team:
			BoardV2.Teams.Red:
				if state[pos].chess_component.position.y >= 7:
					bonus += 10
			BoardV2.Teams.Black:
				if state[pos].chess_component.position.y <= 2:
					bonus += 10
	
	var moves = get_figure_legal_moves(pos, state)
	for move in moves:
		if state.has(move["end"]):
			bonus += 10
	
	return bonus

func get_mobility_bonus(pos: Vector2i, state: Dictionary) -> int:
	return get_figure_legal_moves(pos, state).size()*2

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
	var team: BoardV2.Teams = BoardV2.Teams.Black
	if !maximizingPlayer:
		team = BoardV2.Teams.Red
	if depth == 0 || game_over(state):
		return evaluate_position(state, BoardV2.Teams.Black)
	
	if maximizingPlayer:
		var maxEval = -infinite
		for move in get_all_legal_moves(team, state):
			var new_board = simulate_move(state, move)
			var eval = minimax(new_board, depth - 1, false, alpha, beta)
			maxEval = max(maxEval, eval)
			alpha = max(alpha, eval)
			if beta <= alpha:
				break
		return maxEval
	else:
		var minEval = infinite
		for move in get_all_legal_moves(team, state):
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
		if figure.frozen:
			continue
		var moves: Array[Vector2i] = figure.chess_component.calculate_moves(state, pos)
		for move in moves:
			legal_moves.append({
				"start": pos,
				"end": move
			})
		
	return legal_moves

func get_figure_legal_moves(pos: Vector2i, state: Dictionary) -> Array[Dictionary]:
	var legal_moves: Array[Dictionary] = []
	var figure: FigureComponent = state[pos]
	var moves: Array[Vector2i] = figure.chess_component.calculate_moves(state, pos)
	for move in moves:
		legal_moves.append({
			"start": pos,
			"end": move
		})
	return legal_moves


func game_over(state: Dictionary) -> bool:
	return get_generals(state) != 2

func get_generals(state: Dictionary) -> int:
	var generals: int = 0
	for pos in state:
		if state[pos].type == FigureComponent.Types.GENERAL:
			generals += 1
	return generals

func select_best_move(depth: int) -> void:
	var best_score = -infinite
	var best_move = null
	var moves = get_all_legal_moves(BoardV2.Teams.Black, board.state)
	for move in moves:
		var new_board = simulate_move(board.state, move)
		var score = minimax(new_board, depth - 1, false, -infinite, infinite)
		if score > best_score:
			best_score = score
			best_move = move
	print(best_score)
	if best_move:
		call_deferred("make_move_main_thread", best_move)


func make_move_main_thread(best_move):
	thinking_thread.wait_to_finish()
	board.move_figure_AI(best_move)
