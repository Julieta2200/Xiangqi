class_name Board extends Node

var markers : Array
var state : Array
var select_figure : Figure
var player : int

const board_rows = 10
const board_cols = 9

enum figures_type {General, Soldier}
enum team {Red = 1, Black = 2}

func _ready():
	player = team.Red
	for i in range(board_rows):
		markers.append(get_node("Markers/" + str(i+1)).get_children())
	initialize_board()


func initialize_board():
	for row in range(board_rows):
		state.append([])
		for col in range(board_cols):
			state[row].append(null)


func state_fix(marker):
	if player == team.Red:
		player = team.Black
	else:
		player = team.Red
	for row in range(board_rows):
		for col in range(board_cols):
			if markers[row][col].highlight.visible:
				markers[row][col].highlight.visible = false
			if markers[row][col] == marker:
				select_figure.board_position = Vector2(row,col)

