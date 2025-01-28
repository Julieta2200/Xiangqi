class_name Evaluation extends Node2D

var state_hashes: Dictionary = {}
var results: Array[Dictionary]
var mutex: Mutex = Mutex.new()
var thinking_thread: Thread = Thread.new()


func evaluate_multithread(state: Dictionary, base_eval: float, turn: Board.team, depth: int):
	thinking_thread.start(evaluate.bind(state, base_eval, turn, depth, true))

func evaluate(state: Dictionary, base_eval: float, turn: Board.team, depth: int, upper: bool = false):
	var state_hash: String = generate_state_hash(state, turn)
	if state_hashes.has(state_hash):
		return state_hashes[state_hash]
	
	var best_move: Dictionary = {
		"evaluation": -100
	}
	var evaluation: float
	for pos in state:
		if state[pos].team == turn:
			mutex.lock()
			var moves: Array[Vector2] = state[pos].get_moves(state, pos)
			mutex.unlock()
			for m in moves:
				var tmp_state: Dictionary = state.duplicate()
				var new_base_eval: float = base_eval
				if tmp_state.has(m):
					if tmp_state[m].team == Board.team.Red:
						new_base_eval -= tmp_state[m].value
					else:
						new_base_eval += tmp_state[m].value
				tmp_state[m] = tmp_state[pos]
				tmp_state.erase(pos)
				var bm: Dictionary
				if depth == 0:
					bm = {
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation": new_base_eval
					}
				else:
					bm = {
						"move": {
							"pos": pos,
							"new_pos": m
						},
						"evaluation":  evaluate(tmp_state, new_base_eval, next_turn(turn), depth - 1).evaluation
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

func evaluate_single_state (state: Dictionary) -> float:
	var evaluation: float
	for pos in state:
		if state[pos].team == Board.team.Red:
			evaluation += state[pos].value
		else:
			evaluation -= state[pos].value
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

