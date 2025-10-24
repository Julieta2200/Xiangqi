extends AIV2

const black_pawn_value: int = 26

func select_best_move(position: Array[Array], depth: int) -> void:
	var pawn_positions: Array[Array] = []
	for y in position.size():
		for x in position[y].size():
			if position[y][x] != black_pawn_value:
				continue
			pawn_positions.append([y, x])
	if pawn_positions.size() == 0:
		super.select_best_move(position, depth)
		return

	var pawn_position: Array = pawn_positions[randi() % pawn_positions.size()]
	call_deferred("make_move_main_thread", [pawn_position[0], pawn_position[1], pawn_position[0]-1, pawn_position[1]])
