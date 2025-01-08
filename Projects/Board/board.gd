class_name Board extends Node

var markers : Array
var state : Array
const board_rows = 10
const board_cols = 9

enum figures_type {General, Soldier}
enum team {Red = 1, Black = 2}

func _ready():
	for i in range(board_rows):
		markers.append(get_node("Markers/" + str(i+1)).get_children())
	initialize_board()


func initialize_board():
	for row in range(board_rows):
		state.append([])
		for col in range(board_cols):
			state[row].append(null)
