class_name Board extends Node

const board_rows = 10
const board_cols = 9
enum team {Red = 1, Black = 2}

var markers : Dictionary
var state : Dictionary
var save_states: Dictionary
var selected_figure: Figure
var turn: team:
	set(t):
		turn = t
		calculate_moves()
		if turn == Board.team.Black:
			move_number += 1
			$"..".computer_move()

var move_number: int = 0

var figure_scenes: Dictionary = {
	Figure.Types.General: preload("res://Projects/Figure/General/general.tscn"),
	Figure.Types.Advisor: preload("res://Projects/Figure/Advisor/advisor.tscn"),
	Figure.Types.Soldier: preload("res://Projects/Figure/Soldier/soldier.tscn"),
	Figure.Types.Elephant: preload("res://Projects/Figure/Elephant/elephant.tscn"),
	Figure.Types.Chariot: preload("res://Projects/Figure/Chariot/chariot.tscn")
}

func _ready():
	turn = team.Red
	initialize_board()
	initialize_markers()
	

func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			markers[Vector2(j,i)] = $Markers.get_child(i).get_child(j)
			markers[Vector2(j,i)].board_position = Vector2(j,i)

func initialize_board():
	for row in range(board_rows):
		for col in range(board_cols):
			state[Vector2(col,row)] = null

func create_state(new_state: Dictionary) -> void:
	for key in state:
		if state[key] != null:
			state[key].delete()
			state[key] = null
	
	for key in new_state:
		var figure = figure_scenes[new_state[key].type].instantiate()
		figure.board = self
		figure.team = new_state[key].team
		figure.board_position = key
		figure.active = !new_state[key].has("inactive")
		
		add_child(figure)
	calculate_moves()

func generate_save_state() -> void:
	var generated_state: Dictionary
	for pos in state:
		if state[pos] != null:
			generated_state[pos] = {
				"type": state[pos].type,
				"team": state[pos].team
			}
			if !state[pos].active:
				generated_state[pos].inactive = true
	save_states[move_number] = generated_state

func load_move(move: int) -> void:
	move_number = move
	turn = team.Red
	create_state(save_states[move])

func move(marker):
	unhighlight_markers()
	if state[marker.board_position] != null:
		state[marker.board_position].delete()
	selected_figure.board_position = marker.board_position
	
	turn = team.Black

func unhighlight_markers():
	for key in markers:
		markers[key].unhighlight()

func computer_move(pos: Vector2, new_pos: Vector2):
	if state[new_pos] != null:
		state[new_pos].delete()
	state[pos].board_position = new_pos
	turn = team.Red
	generate_save_state()

func calculate_moves():
	for pos in state:
		if state[pos] != null and state[pos].team == turn:
			state[pos].calculate_moves()

func valid_future_state(pos: Vector2, new_pos: Vector2, future_state: Dictionary) -> bool:
	var tmp_state: Dictionary = future_state.duplicate()
	tmp_state[new_pos] = tmp_state[pos]
	tmp_state[pos] = null
	
	var generals = get_generals(tmp_state)
	if generals_facing(tmp_state, generals):
		return false
	
	if pawn_check(tmp_state, generals):
		return false
		
	if chariot_check(tmp_state, generals):
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

func pawn_check(state: Dictionary, generals: Dictionary) -> bool:
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

func chariot_check(state: Dictionary, generals: Dictionary) -> bool:
	var directions = [
		Vector2.LEFT,
		Vector2.RIGHT
	]
	
	match turn:
		team.Red:
			directions.append(Vector2(0, 1))
		team.Black:
			directions.append(Vector2(0, -1))

	var boundaries = {
			"y": Vector2(0,9),
			"x": Vector2(0,8)
		}

	for dir in directions:
		var check_pos = generals[turn] + dir
		while check_pos.x >= boundaries["x"].x and check_pos.x <= boundaries["x"].y \
		and check_pos.y >= boundaries["y"].x and check_pos.y <= boundaries["y"].y:
			if state[check_pos] != null:
				if state[check_pos].type == Figure.Types.Chariot and state[check_pos].team != turn:
					return true 
				break
			check_pos += dir
	
	return false


func get_figures(t: team, type: Figure.Types) -> Array[Figure]:
	var figures: Array[Figure] = []
	for pos in state:
		if state[pos] != null:
			if state[pos].type == t and state[pos].team == t:
				figures.append(state[pos])
	
	return figures

func get_figures_by_team(t: team) -> Array[Figure]:
	var figures: Array[Figure] = []
	for pos in state:
		if state[pos] != null:
			if state[pos].team == t:
				figures.append(state[pos])
	
	return figures
