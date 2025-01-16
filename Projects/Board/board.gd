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
			state[Vector2(col,row)] = null


func move(marker):
	for row in range(board_rows):
		for col in range(board_cols):
			markers[row][col].unhighlight()
			if markers[row][col] == marker:
				if state[Vector2(col,row)] != null && state[Vector2(col,row)].team != selected_figure.team:
					state[Vector2(col,row)].delete()
				selected_figure.board_position = Vector2(col,row)
	
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
	
	var generals = get_generals(tmp_state)
	
	if generals_facing(tmp_state, generals):
		return false
	
	if pawn_check(generals):
		return false
	
	return true

func get_generals(state: Dictionary) -> Dictionary:
	var generals: Dictionary
	for pos in state:
		if state[pos] != null and state[pos].type == Figure.Types.General:
			generals[state[pos].team] = pos
	return generals

func generals_facing(state: Dictionary, generals: Dictionary) -> bool:
	if generals[team.Red].x != generals[team.Black].x:
		return false
		
		
	var tmp_y = generals[team.Red].y + 1

	while tmp_y < board_rows:
		if state[Vector2(generals[team.Red].x, tmp_y)] != null:
			return state[Vector2(generals[team.Red].x, tmp_y)].type == Figure.Types.General
		tmp_y += 1
	
	return true

func pawn_check(generals: Dictionary) -> bool:
	var directions = [
		Vector2.LEFT,
		Vector2.RIGHT
	]
	
	match turn:
		team.Red:
			directions.append(Vector2(0, 1))
		team.Black:
			directions.append(Vector2(0, -1))
	
	for dir in directions:
		var check_pos = generals[turn] + dir
		if state[check_pos] != null and state[check_pos].type == Figure.Types.Soldier \
		and state[check_pos].team != turn:
			return true

	return false




