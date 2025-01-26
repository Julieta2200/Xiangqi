class_name Evaluation extends Node2D

var state_hashes: Dictionary = {}
var states: Array[Dictionary] = []
var results: Array[Dictionary]
var evaluations: Array[Dictionary]
var mutex: Mutex = Mutex.new()


var t: int

func evaluate_multithread(state: Dictionary, base_eval: float, turn: Board.team, depth: int):
	t = Time.get_unix_time_from_system()
	states = []
	evaluations = []
	for pos in state:
		if state[pos].team == turn:
			var moves: Array[Vector2] = state[pos].get_moves(state, pos)
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
				states.append({"state": tmp_state, "turn": next_turn(turn), "base_eval": new_base_eval, "depth": depth - 1})
	
	var task_id = WorkerThreadPool.add_group_task(evaluate_chunk, states.size())
	
	WorkerThreadPool.wait_for_group_task_completion(task_id)
	print(Time.get_unix_time_from_system() - t)

func evaluate_chunk(index: int):
	var result = evaluate(states[index].state, states[index].base_eval, states[index].turn, states[index].depth)
	evaluations.append(result)



func split_array(arr: Array, num_parts: int) -> Array:
	var result = []
	var part_size = int(arr.size() / num_parts)
	var remainder = arr.size() % num_parts
	
	var start_idx = 0
	for i in range(num_parts):
		var end_idx = start_idx + part_size + (1 if i < remainder else 0)
		result.append(arr.slice(start_idx, end_idx))
		start_idx = end_idx
	
	return result

func evaluate(state: Dictionary, base_eval: float, turn: Board.team, depth: int, upper: bool = false):
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
	
	return best_move

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

