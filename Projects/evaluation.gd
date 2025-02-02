class_name Evaluation extends Node2D

var results: Array[Dictionary]
var mutex: Mutex = Mutex.new()
var thinking_thread: Thread = Thread.new()

var _t: float

# Performance: 2.66915988922119
# Performance: 3.33373785018921
# Performance: 3.24588418006897
# Performance: 2.75684595108032
# Performance: 16.8449511528015
# Performance: 16.2276890277863
# Performance: 3.03015899658203

func evaluate_multithread(state: Dictionary, turn: Board.team, depth: int):
	_t = Time.get_unix_time_from_system()
	thinking_thread.start(evaluate.bind(state, turn, depth, true))
#	evaluate(state, turn, depth, true)

func evaluate(state: Dictionary, turn: Board.team, depth: int, upper: bool = false):
	var best_move: Dictionary = {
		"evaluation": -100
	}
	var evaluation: float
	var keys: Array = state.keys()
	for pos in keys:
		if state[pos].team == turn:
			var moves: Array[Vector2] = state[pos].get_moves(state, pos)
			for m in moves:
				var tmp_obj: Figure
				if state.has(m):
					tmp_obj = state[m]
				state[m] = state[pos]
				state.erase(pos)
				
				var bm: Dictionary
				if depth == 0:
					bm = {
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation": evaluate_single_state(state)
					}
				else:
					bm = {
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation":  evaluate(state, next_turn(turn), depth - 1).evaluation
					}
				
				state[pos] = state[m]
				if tmp_obj != null:
					state[m] = tmp_obj
				else:
					state.erase(m)
				if best_move.evaluation == -100:
					best_move = bm
				if turn == Board.team.Red:
					if best_move.evaluation < bm.evaluation:
						best_move = bm
				else:
					if best_move.evaluation > bm.evaluation:
						best_move = bm

	if best_move.evaluation == -100:
		if turn == Board.team.Red:
			best_move.evaluation = -1000
		else:
			best_move.evaluation = 1000
	
	if upper:
		call_deferred("move_ready")
	return best_move

func move_ready():
	var move: Dictionary = thinking_thread.wait_to_finish()
	%Board.computer_move(move.move.pos, move.move.new_pos)
	print(move)
	print("Performance: " + str(Time.get_unix_time_from_system() - _t))

func evaluate_single_state (state: Dictionary) -> float:
	var evaluation: float
	var keys: Array = state.keys()
	for pos in keys:
		evaluation += state[pos].calculate_value(state, pos)
	
	return evaluation

func next_turn(turn: Board.team) -> Board.team:
	if turn == Board.team.Red:
		return Board.team.Black
	return Board.team.Red


