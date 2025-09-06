class_name AIV2 extends Node

@export var board: BoardV2

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

var figure_legal_moves = {
	0: general_moves,
	1: advisor_moves,
	2: chariot_moves,
	3: cannon_moves,
	4: horse_moves,
	5: elephant_moves,
	6: soldier_moves,
}

func _ready() -> void:
	randomize()

func make_move() -> bool:
	var position: Array[Array] = state_to_position(board.state)
	select_best_move(position, 3)
	return true

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
		position[pos.y][pos.x] = number
		
	return position

func select_best_move(position: Array[Array], depth: int) -> void:
	var legal_moves: Array[Array] = get_all_legal_moves(team_numbers[BoardV2.Teams.Black], position)
	print(legal_moves)

func get_all_legal_moves(team: int, position: Array[Array]) -> Array[Array]:
	var legal_moves: Array[Array] = []
	for y in position.size():
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
				legal_moves.append([fly_start, start_x])
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
		[[-1,2],[0,1]],
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
		 and position[start_y + d[0]/2][start_x + d[0]/2] == 0 \
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
	var piece_number: int = position[y][x] - 10*other_team(team)
	if piece_number >= 0 and piece_number < 10:
		return true
	return false
	
func other_team(team: int) -> int:
	if team == 1:
		return 2
	return 1
