extends AIV2


func _ready() -> void:
	super._ready()
	figure_values[1] = 10000

func select_best_move(position: Array[Array], _depth: int) -> void:
	var moves: Array[Array] = get_all_legal_moves(team_numbers[BoardV2.Teams.Black], position)
	
	# If there are no legal moves, we can't make a move
	if moves.is_empty():
		return
	
	# Categorize moves
	var capture_moves: Array[Array] = []
	var closing_to_palace_moves: Array[Array] = []
	var other_moves: Array[Array] = []
	
	for move in moves:
		var start_y: int = move[0]
		var end_y: int = move[2]
		var end_x: int = move[3]
		
		# Check if it's a capture move
		if position[end_y][end_x] != 0:
			var piece_number: int = abs(position[end_y][end_x]) - 10*team_numbers[BoardV2.Teams.Red]
			if piece_number >= 0 and piece_number < 10:
				capture_moves.append(move)
				continue
		
		# Check if it's closing to palace (enemy palace for Black team is Red's palace at y=0,1,2)
		# For Black team, moving towards Red's palace means moving UP (decreasing y in array)
		# We want moves that either end in the palace OR move forward towards it (not sideways or backwards)
		var end_pos: Vector2i = Vector2i(end_x, end_y)
		var is_forward_move: bool = end_y < start_y  # Moving up (decreasing y) towards enemy palace
		var is_backward_move: bool = end_y > start_y  # Moving down (increasing y) away from palace
		var ends_in_palace: bool = BoardV2.palace_positions.has(end_pos) and end_y <= 2
		
		# Only consider forward moves (not sideways or backwards) that advance towards the palace
		# Moves that end in palace AND are forward (or at least not backward), 
		# OR forward moves that are in the palace x-range (3-5) and past the river (y <= 4)
		var is_in_palace_x_range: bool = end_x >= 3 and end_x <= 5
		
		# Don't allow backward moves
		if is_backward_move:
			other_moves.append(move)
			continue
		
		if (ends_in_palace and not is_backward_move) or (is_forward_move and is_in_palace_x_range and end_y <= 4):
			closing_to_palace_moves.append(move)
			continue
		
		# Otherwise it's an other move
		other_moves.append(move)
	
	# Select move based on priority
	var best_move: Array = moves[0]  # Fallback to first move
	
	if not capture_moves.is_empty():
		# Select the capture move with the highest value
		var best_capture_value: int = -1
		for capture_move in capture_moves:
			var end_y: int = capture_move[2]
			var end_x: int = capture_move[3]
			var captured_piece: int = position[end_y][end_x]
			var piece_number: int = abs(captured_piece) - 10*team_numbers[BoardV2.Teams.Red]
			var piece_value: int = figure_values[piece_number]
			if piece_value > best_capture_value:
				best_capture_value = piece_value
				best_move = capture_move
	elif not closing_to_palace_moves.is_empty():
		best_move = closing_to_palace_moves[randi() % closing_to_palace_moves.size()]
	elif not other_moves.is_empty():
		best_move = other_moves[randi() % other_moves.size()]
	
	# Make the move
	call_deferred("make_move_main_thread", best_move)