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
	
	if generals_facing(tmp_state):
		return false
	
	return true


func generals_facing(state: Dictionary) -> bool:
	var generals: Dictionary
	for pos in state:
		if state[pos] != null and state[pos].type == Figure.Types.General:
			generals[state[pos].team] = pos
	
	if generals[team.Red].x != generals[team.Black].x:
		return false
	
	var tmp_y = generals[team.Red].y + 1
	
	while tmp_y < board_rows and state[Vector2(generals[team.Red].x, tmp_y)] != null\
	and state[Vector2(generals[team.Red].x, tmp_y)].type != Figure.Types.General:
		if state[Vector2(generals[team.Red].x, tmp_y)] != null:
			return false
	
	return true
