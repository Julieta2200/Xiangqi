class_name Board extends Node

const board_rows = 10
const board_cols = 9
enum team {Red = 1, Black = 2}

var markers : Array[Array]
var state : Dictionary
var selected_figure: Figure
var turn: team

func _ready():
	turn = team.Red
	for i in range(board_rows):
		markers.append(get_node("Markers/" + str(i+1)).get_children())
	initialize_board()


func initialize_board():
	for row in range(board_rows):
		for col in range(board_cols):
			state[Vector2(row,col)] = null


func move(marker):
	for row in range(board_rows):
		for col in range(board_cols):
			markers[row][col].unhighlight()
			if markers[row][col] == marker:
				if state[Vector2(row,col)] != null && state[Vector2(row,col)].team != selected_figure.team:
					state[Vector2(row,col)].delete_figure()
				selected_figure.board_position = Vector2(row,col)
	
	if turn == team.Red:
		turn = team.Black
	else:
		turn = team.Red
	
	calculate_moves()

func calculate_moves():
	for pos in state:
		if state[pos] != null and state[pos].team == turn:
			state[pos].calculate_moves()

func valid_state(pos: Vector2, new_pos: Vector2) -> bool:
	var tmp_state: Dictionary = state.duplicate()
	tmp_state[new_pos] = tmp_state[pos]
	tmp_state[pos] = null
	
	if generals_facing(tmp_state):
		return false
	
	return true


func generals_facing(state: Dictionary) -> bool:
	var generals: Dictionary
	for pos in state:
		if state[pos] != null and state[pos].type == Figure.Types.General:
			generals[state[pos].team] = pos

	if pawn_check(generals):
		return true
		
	if generals[team.Red].y != generals[team.Black].y:
		return false
		
		
	var tmp_x = generals[team.Red].x + 1

	while tmp_x < board_rows:
		if state[Vector2(tmp_x ,generals[team.Red].y)] != null:
			return state[Vector2(tmp_x ,generals[team.Red].y)].type == Figure.Types.General
		tmp_x += 1
	
	return true

func pawn_check(generals: Dictionary) -> bool:
	var directions = [
		Vector2(0, -1),
		Vector2(0, 1)
	]

	for team_key in generals.keys():
		match team_key:
			team.Red:
				directions.append(Vector2(1, 0))
			team.Black:
				directions.append(Vector2(-1, 0))
		for dir in directions:
			var check_pos = generals[team_key] + dir
			if state[check_pos] != null and state[check_pos].type == Figure.Types.Soldier:
				return true

	return false




