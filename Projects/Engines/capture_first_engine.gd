extends ComputerEngine

func make_move() -> void:
	await get_tree().create_timer(1).timeout 
	randomize()
	var figures: Array[Figure] = %Board.get_figures_by_team(Board.team.Black)
	var captures: Array[Dictionary] = []
	var movable_figures: Array[Figure]
	for figure in figures:
		if figure.valid_moves.size() > 0:
			movable_figures.append(figure)
		for move in figure.valid_moves:
			if %Board.state[move] != null:
				captures.append({
					"pos": figure.board_position,
					"new_pos": move
				})
	
	if movable_figures.size() == 0:
		print("lost")
		return
	
	if captures.size() > 0:
		var capture: Dictionary = captures.pick_random()
		%Board.computer_move(capture.pos, capture.new_pos)
	else:
		var figure: Figure = movable_figures.pick_random()
		var move = figure.valid_moves.pick_random()
		%Board.computer_move(figure.board_position, move)
