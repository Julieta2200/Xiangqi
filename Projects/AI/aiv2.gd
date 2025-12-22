class_name AIV2 extends Node

@export var board: BoardV2
@export var special: CardSlots.SPECIALS
@export var depth: int = 3
var _special_used: bool = false
var script_use_special: bool = false

const infinite : int = 500000
var thinking_thread: Thread = Thread.new()

const team_numbers = {
	BoardV2.Teams.Red: 1,
	BoardV2.Teams.Black: 2,
	BoardV2.Teams.Wall: 3
}

const figure_numbers = {
	FigureComponent.Types.GENERAL: 0,
	FigureComponent.Types.ADVISOR: 1,
	FigureComponent.Types.CHARIOT: 2,
	FigureComponent.Types.CANNON: 3,
	FigureComponent.Types.HORSE: 4,
	FigureComponent.Types.ELEPHANT: 5,
	FigureComponent.Types.SOLDIER: 6,
}

var figure_values: Array[int] = [
	10000, # general
	20, # advisor
	90, # chariot
	45, # cannon
	40, # horse
	20, # elephant
	10, # soldier
]

var figure_legal_moves = {
	0: general_moves,
	1: advisor_moves,
	2: chariot_moves,
	3: cannon_moves,
	4: horse_moves,
	5: elephant_moves,
	6: soldier_moves,
}

var moved_numbers: Array[int] = []
var current_eval: int = 0 :
	set(e):
		current_eval = e
var transposition_table: Dictionary = {}


func _ready() -> void:
	randomize()

func make_move() -> bool:
	call_deferred("use_special")
	var position: Array[Array] = state_to_position(board.state)
	thinking_thread.start(select_best_move.bind(position,depth))
	return true

func make_move_main_thread(best_move):
	thinking_thread.wait_to_finish()
	board.move_figure_AI({"start": Vector2i(best_move[1], best_move[0]), 
	"end": Vector2i(best_move[3],best_move[2])})

func state_to_position(state: Dictionary) -> Array[Array]:
	var position: Array[Array] = [
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
	]
	for pos in state:
		var figure: FigureComponent = state[pos]
		var number: int = 10*team_numbers[figure.chess_component.team] + figure_numbers[figure.type]
		if figure.frozen:
			number *= -1
		position[pos.y][pos.x] = number
		
	return position

func select_best_move(position: Array[Array], depth: int) -> void:
	# Recalculate the entire board score from scratch before thinking.
	current_eval = calculate_full_evaluation(position)

	var best_score = -infinite
	var best_move = null
	var moves: Array[Array] = get_all_legal_moves(team_numbers[BoardV2.Teams.Black], position)
	
	# If there are no legal moves, we can't make a move
	if moves.is_empty():
		return
	
	# Always initialize best_move to the first move as a fallback
	# This ensures we make SOME move even if all evaluations are equally bad
	best_move = moves[0]
	
	for move in moves:
		simulate_move(position, move)
		var score = minimax(position, depth - 1, false, -infinite, infinite)
		undo_move(position, move)
		if score > best_score:
			best_score = score
			best_move = move
	
	# At this point, best_move should always be set (either first move or best found)
	if best_move:
		call_deferred("make_move_main_thread", best_move)

func get_all_legal_moves(team: int, position: Array[Array]) -> Array[Array]:
	var legal_moves: Array[Array] = []
	for y in position.size():
		# Consider mist when calculating the moves
		if board._mist != null and team_numbers[board._mist.target_team + 1] == team:
			match team:
				1:
					if y >= 5:
						continue
				2:
					if y <= 4:
						continue
		for x in position[y].size():
			# empty cell or inactive figure
			if position[y][x] <= 0:
				continue
			var figure_number: int = position[y][x] - 10*team
			# wrong team
			if figure_number >= 10 or figure_number < 0:
				continue
			var new_moves: Array[Array] = figure_legal_moves[figure_number].call(team, position, y, x)
			legal_moves.append_array(new_moves)
	return legal_moves

func general_moves(team: int, position: Array[Array], start_y: int, start_x: int) -> Array[Array]:
	var legal_moves: Array[Array] = []
	const boundaries = {
		1: [
			[0,2],
			[3,5]
		],
		2: [
			[7,9],
			[3,5]
		]
	}
	
	const directions = [
		[0,1],
		[0,-1],
		[1,0],
		[-1,0]
	]
	
	const fly_directions = {
		1: 1,
		2: -1
	}
	
	for d in directions:
		var new_y: int = start_y + d[0]
		var new_x: int = start_x + d[1]
		if !in_boundaries(boundaries[team], new_y, new_x):
			continue
		if !free_or_capture(position, new_y, new_x, team):
			continue
		legal_moves.append([start_y, start_x, new_y, new_x])
	
	var fly_start: int = start_y + fly_directions[team]
	while fly_start >= 0 and fly_start < 10:
		if position[fly_start][start_x] != 0:
			if position[fly_start][start_x] == other_team(team)*10 + figure_numbers[FigureComponent.Types.GENERAL]:
				legal_moves.append([start_y, start_x, fly_start, start_x])
			break
		fly_start += fly_directions[team]
	return legal_moves

func advisor_moves(team: int, position: Array[Array], start_y: int, start_x: int) -> Array[Array]:
	var legal_moves: Array[Array] = []
	const boundaries = {
		1: [
			[0,2],
			[3,5]
		],
		2: [
			[7,9],
			[3,5]
		]
	}
	
	const directions = [
		[1,1],
		[1,-1],
		[-1,1],
		[-1,-1]
	]
	
	for d in directions:
		var new_y: int = start_y + d[0]
		var new_x: int = start_x + d[1]
		if !in_boundaries(boundaries[team], new_y, new_x):
			continue
		if !free_or_capture(position, new_y, new_x, team):
			continue
		legal_moves.append([start_y, start_x, new_y, new_x])
	return legal_moves

func chariot_moves(team: int, position: Array[Array], start_y: int, start_x: int) -> Array[Array]:
	var legal_moves: Array[Array] = []
	const boundaries = {
		1: [
			[0,9],
			[0,8]
		],
		2: [
			[0,9],
			[0,8]
		]
	}
	
	const directions = [
		[1,0],
		[-1,0],
		[0,1],
		[0,-1]
	]
	
	for d in directions:
		var new_y: int = start_y + d[0]
		var new_x: int = start_x + d[1]
		while in_boundaries(boundaries[team], new_y, new_x):
			if position[new_y][new_x] == 0:
				legal_moves.append([start_y, start_x, new_y, new_x])
			else:
				if free_or_capture(position, new_y, new_x, team):
					legal_moves.append([start_y, start_x, new_y, new_x])
				break
			new_y += d[0]
			new_x += d[1]
	
	return legal_moves

func cannon_moves(team: int, position: Array[Array], start_y: int, start_x: int) -> Array[Array]:
	var legal_moves: Array[Array] = []
	const boundaries = {
		1: [
			[0,9],
			[0,8]
		],
		2: [
			[0,9],
			[0,8]
		]
	}
	
	const directions = [
		[1,0],
		[-1,0],
		[0,1],
		[0,-1]
	]
	
	for d in directions:
		var new_y: int = start_y + d[0]
		var new_x: int = start_x + d[1]
		var have_anchor: bool = false
		while in_boundaries(boundaries[team], new_y, new_x):
			if position[new_y][new_x] == 0 and !have_anchor:
				legal_moves.append([start_y, start_x, new_y, new_x])
			elif !have_anchor:
				have_anchor = true
			elif position[new_y][new_x] != 0:
				if free_or_capture(position, new_y, new_x, team):
					legal_moves.append([start_y, start_x, new_y, new_x])
				break
			new_y += d[0]
			new_x += d[1]
	
	return legal_moves

func horse_moves(team: int, position: Array[Array], start_y: int, start_x: int) -> Array[Array]:
	var legal_moves: Array[Array] = []
	const boundaries = {
		1: [
			[0,9],
			[0,8]
		],
		2: [
			[0,9],
			[0,8]
		]
	}
	const directions = [
		[[-2,-1],[-1,0]],
		[[-2,1],[-1,0]],
		[[2,-1],[1,0]],
		[[2,1],[1,0]],
		[[-1,-2],[0,-1]],
		[[1,-2],[0,-1]],
		[[-1,2],[0,1]],
		[[1,2],[0,1]],
	]
	for d in directions:
		var new_y: int = start_y + d[0][0]
		var new_x: int = start_x + d[0][1]
		var blocker_pos = d[1]
		if in_boundaries(boundaries[team], new_y, new_x) \
		 and position[start_y + blocker_pos[0]][start_x + blocker_pos[1]] == 0 \
		 and free_or_capture(position, new_y, new_x, team):       
			legal_moves.append([start_y, start_x, new_y, new_x])
	
	
	return legal_moves

func elephant_moves(team: int, position: Array[Array], start_y: int, start_x: int) -> Array[Array]:
	var legal_moves: Array[Array] = []
	const boundaries = {
		1: [
			[0,4],
			[0,8]
		],
		2: [
			[5,9],
			[0,8]
		]
	}
	
	const directions = [
		[-2,2],
		[-2,-2],
		[2,2],
		[2,-2]
	]
	
	for d in directions:
		var new_y: int = start_y + d[0]
		var new_x: int = start_x + d[1]
		if in_boundaries(boundaries[team], new_y, new_x) \
		 and position[start_y + d[0]/2][start_x + d[1]/2] == 0 \
		 and free_or_capture(position, new_y, new_x, team):
			legal_moves.append([start_y, start_x, new_y, new_x])	
	
	return legal_moves

func soldier_moves(team: int, position: Array[Array], start_y: int, start_x: int) -> Array[Array]:
	var legal_moves: Array[Array] = []
	const boundaries = {
		1: [
			[0,9],
			[0,8]
		],
		2: [
			[0,9],
			[0,8]
		]
	}
	
	var directions = []
	match team:
		1:
			directions.append([1,0])
			if start_y >= 5:
				directions.append_array([[0,-1],[0,1]])
		2:
			directions.append([-1,0])
			if start_y <= 4:
				directions.append_array([[0,-1],[0,1]])
	
	for d in directions:
		var new_y: int = start_y + d[0]
		var new_x: int = start_x + d[1]
		if in_boundaries(boundaries[team], new_y, new_x) \
		 and free_or_capture(position, new_y, new_x, team):
			legal_moves.append([start_y, start_x, new_y, new_x])
	
	return legal_moves

func in_boundaries(boundaries: Array, y: int, x: int) -> bool:
	if y < boundaries[0][0] or y > boundaries[0][1]:
		return false
	if x < boundaries[1][0] or x > boundaries[1][1]:
		return false
	return true

func free_or_capture(position: Array[Array], y: int, x: int, team: int) -> bool:
	if position[y][x] == 0:
		return true
	var piece_number: int = abs(position[y][x]) - 10*other_team(team)
	if piece_number >= 0 and piece_number < 10:
		return true
	return false
	
func other_team(team: int) -> int:
	if team == 1:
		return 2
	return 1

func simulate_move(position: Array[Array], move: Array) -> void:
	var sy = move[0]
	var sx = move[1]
	var dy = move[2]
	var dx = move[3]

	var moving_piece = position[sy][sx]
	var captured_piece = position[dy][dx]

	moved_numbers.append(captured_piece)

	# --- remove old bonuses for moving piece ---
	var m_team = get_team_number(abs(moving_piece))
	var m_fig = get_figure_number(abs(moving_piece), m_team)
	# --- remove captured piece’s contribution ---
	if captured_piece != 0:
		var c_team = get_team_number(abs(captured_piece))
		var c_fig = get_figure_number(abs(captured_piece), c_team)
		var val = figure_values[c_fig]
		
		if c_team == 2: current_eval -= val
		elif c_team == 1: current_eval += val

	# move piece
	position[dy][dx] = moving_piece
	position[sy][sx] = 0


func undo_move(position: Array[Array], move: Array) -> void:
	var sy = move[0]
	var sx = move[1]
	var dy = move[2]
	var dx = move[3]

	var moving_piece = position[dy][dx]
	var captured_piece = moved_numbers.pop_back()

	var m_team = get_team_number(abs(moving_piece))
	var m_fig = get_figure_number(abs(moving_piece), m_team)


	# restore captured piece
	if captured_piece != 0:
		var c_team = get_team_number(abs(captured_piece))
		var c_fig = get_figure_number(abs(captured_piece), c_team)
		var val = figure_values[c_fig]
		if c_team == 2: current_eval += val
		elif c_team == 1: current_eval -= val


	# move back
	position[sy][sx] = moving_piece
	position[dy][dx] = captured_piece

	
func minimax(position: Array[Array], depth: int, maximizingPlayer: bool, alpha: int, beta: int) -> int:
	var team: int = 2
	if !maximizingPlayer:
		team = 1
	if depth == 0 or game_over():
		var eval = evaluate_position(position, 2)
		# print("Eval at depth ", depth, ": ", eval)
		return eval
	var key = position_hash(position, depth, maximizingPlayer)
	if transposition_table.has(key):
		return transposition_table[key]
	
	if maximizingPlayer:
		var maxEval = -infinite
		for move in get_all_legal_moves(team, position):
			simulate_move(position, move)
			var eval = minimax(position, depth - 1, false, alpha, beta)
			undo_move(position, move)
			maxEval = max(maxEval, eval)
			alpha = max(alpha, eval)
			if beta <= alpha:
				break
		transposition_table[key] = maxEval
		# print("MaxEval at depth ", depth, ": ", maxEval)
		return maxEval
	else:
		var minEval = infinite
		for move in get_all_legal_moves(team, position):
			simulate_move(position, move)
			var eval = minimax(position, depth - 1, true, alpha, beta)
			undo_move(position, move)
			minEval = min(minEval, eval)
			beta = min(beta, eval)
			if beta <= alpha:
				break
		transposition_table[key] = minEval
		# print("MinEval at depth ", depth, ": ", minEval)
		return minEval

func game_over() -> bool:
	return moved_numbers.has(10) or moved_numbers.has(20)
	
func evaluate_position(position: Array[Array], team: int) -> int:
	return current_eval

func get_figure_number(number: int, team: int) -> int:
	return number - 10*team

func get_team_number(number: int) -> int:
	return number/10

func position_hash(position: Array[Array], depth: int, maximizing: bool) -> String:
	var hash := ""
	for y in range(10):
		for x in range(9):
			hash += str(position[y][x]) + ","
	hash += str(depth) + "," + str(maximizing)
	return hash


func use_special() -> void:
	if _special_used:
		return
	match special:
		CardSlots.SPECIALS.DisconnectionMistCard:
			disconnection_mist()

func disconnection_mist() -> void:
	var enemy_count: int = 0
	for pos in board.state:
		if pos.y >= 5:
			if board.state[pos].chess_component.team == BoardV2.Teams.Red:
				enemy_count += 1
	
	#  if there are 2 enemies on AI side of board
	if enemy_count >= 2 or script_use_special:
		_special_used = board.activate_disconnection_mist(BoardV2.Teams.Red)

func calculate_full_evaluation(position: Array[Array]) -> int:
	var total_eval: int = 0
	for y in position.size():
		for x in position[y].size():
			var piece = position[y][x]
			if piece == 0:
				continue
			
			var team = get_team_number(abs(piece))
			var figure_num = get_figure_number(abs(piece), team)
			
			var value = figure_values[figure_num]
			
			var piece_score = value
			
			# AI is team 2 (Black), so its pieces are positive.
			# Player is team 1 (Red), so its pieces are negative.
			if team == 2:
				total_eval += piece_score
			else:
				total_eval -= piece_score
				
	return total_eval
