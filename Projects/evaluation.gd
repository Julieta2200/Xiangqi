class_name Evaluation extends Node2D

var state_hashes: Dictionary = {}
var evaluation_hashes: Dictionary = {}
var results: Array[Dictionary]
var mutex: Mutex = Mutex.new()
var thinking_thread: Thread = Thread.new()

var _t: float

# Performance: 2.66915988922119
# Performance: 3.33373785018921
# Performance: 3.24588418006897
# Performance: 2.75684595108032

func evaluate_multithread(state: Dictionary, turn: Board.team, depth: int):
	_t = Time.get_unix_time_from_system()
	thinking_thread.start(evaluate.bind(state, turn, depth, true))

func evaluate(state: Dictionary, turn: Board.team, depth: int, upper: bool = false):
	var state_hash: String = generate_state_hash(state, turn)
	if state_hashes.has(state_hash):
		return state_hashes[state_hash]
	
	var best_move: Dictionary = {
		"evaluation": -100
	}
	var evaluation: float
	for pos in state:
		if state[pos].team == turn:
			var moves: Array[Vector2] = state[pos].get_moves(state, pos, state_hash)
			for m in moves:
				var tmp_state: Dictionary = state.duplicate()
				tmp_state[m] = tmp_state[pos]
				tmp_state.erase(pos)
				var bm: Dictionary
				if depth == 0:
					bm = {
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation": evaluate_single_state(tmp_state, state_hash)
					}
				else:
					bm = {
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation":  evaluate(tmp_state, next_turn(turn), depth - 1).evaluation
					}

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
	
	state_hashes[state_hash] = best_move.evaluation
	
	if upper:
		state_hashes = {}
		call_deferred("move_ready")
	return best_move

func move_ready():
	var move: Dictionary = thinking_thread.wait_to_finish()
	%Board.computer_move(move.move.pos, move.move.new_pos)
	print("Performance: " + str(Time.get_unix_time_from_system() - _t))

func evaluate_single_state (state: Dictionary, state_hash: String) -> float:
	if evaluation_hashes.has(state_hash):
		return evaluation_hashes[state_hash]
	
	var evaluation: float
	for pos in state:
		evaluation += state[pos].calculate_value(state)
	
	evaluation_hashes[state_hash] = evaluation
	
	return evaluation


func next_turn(turn: Board.team) -> Board.team:
	if turn == Board.team.Red:
		return Board.team.Black
	return Board.team.Red

func generate_state_hash(state: Dictionary, turn: Board.team) -> String:
	var state_hash: String = str(turn)
	for pos in state:
		state_hash += str(state[pos].type) + str(pos.x) + str(pos.y)
	return state_hash

