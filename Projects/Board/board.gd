class_name Board extends Node

const board_rows = 10
const board_cols = 9
enum team {Red = 1, Black = 2}
signal _reset

const palace_positions: Dictionary = {
	Vector2(3,0): true,
	Vector2(4,0): true,
	Vector2(5,0): true,
	Vector2(3,1): true,
	Vector2(4,1): true,
	Vector2(5,1): true,
	Vector2(3,2): true,
	Vector2(4,2): true,
	Vector2(5,2): true,
	Vector2(3,7): true,
	Vector2(4,7): true,
	Vector2(5,7): true,
	Vector2(3,8): true,
	Vector2(4,8): true,
	Vector2(5,8): true,
	Vector2(3,9): true,
	Vector2(4,9): true,
	Vector2(5,9): true
}

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

@export var groups: Dictionary = {
	team.Red: "",
	team.Black: ""
}


var figure_scenes: Dictionary = {
	Figure.Types.General: "res://Projects/Figure/{GROUP}/General/general.tscn",
	Figure.Types.Advisor: "res://Projects/Figure/{GROUP}/Advisor/advisor.tscn",
	Figure.Types.Soldier: "res://Projects/Figure/{GROUP}/Soldier/soldier.tscn",
	Figure.Types.Elephant: "res://Projects/Figure/{GROUP}/Elephant/elephant.tscn",
	Figure.Types.Chariot: "res://Projects/Figure/{GROUP}/Chariot/chariot.tscn",
	Figure.Types.Horse: "res://Projects/Figure/{GROUP}/Horse/horse.tscn",
	Figure.Types.Cannon: "res://Projects/Figure/{GROUP}/Cannon/cannon.tscn",
}

var _counter: int 

signal _set_figure(marker: BoardMarker)

func _ready():
	turn = team.Red
	initialize_markers()
	

func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			markers[Vector2(j,i)] = $Markers.get_child(i).get_child(j)
			markers[Vector2(j,i)].board_position = Vector2(j,i)


func create_state(new_state: Dictionary) -> void:
	state = {}
	for key in new_state:
		var figure : Figure
		var figure_scene : String = figure_scenes[new_state[key].type]
		figure_scene = figure_scene.replace("{GROUP}", new_state[key].group)
		figure = load(figure_scene).instantiate()
		figure.board = self
		figure.team = new_state[key].team
		figure.board_position = key
		
		figure.global_position = markers[key].global_position
		
		figure.active = !new_state[key].has("inactive")
		add_child(figure)
	
	calculate_moves()

func generate_save_state() -> void:
	var generated_state: Dictionary
	for pos in state:
		generated_state[pos] = {
			"type": state[pos].type,
			"team": state[pos].team,
			"group": groups[state[pos].team]
		}
		
		if !state[pos].active:
			generated_state[pos].inactive = true
	save_states[move_number] = generated_state

func load_move(move: int) -> void:
	move_number = move
	turn = team.Red
	create_state(save_states[move])

func unhighlight_markers():
	for key in markers:
		markers[key].unhighlight()

func computer_move(pos: Vector2, new_pos: Vector2):
	unhighlight_markers()
	if state.has(new_pos):
		state[new_pos].delete()
	state[pos].move(markers[new_pos])
	turn = team.Red
	generate_save_state()

func calculate_moves():
	var keys: Array = state.keys()
	for pos in keys:
		if state[pos].team == turn:
			state[pos].calculate_moves()

func get_generals(state: Dictionary) -> Dictionary:
	var generals: Dictionary
	for pos in state:
		if state[pos].type == Figure.Types.General:
			generals[state[pos].team] = pos
	return generals
	
func get_figures(t: team, type: Figure.Types) -> Array[Figure]:
	var figures: Array[Figure] = []
	for pos in state:
		if state[pos].type == type and state[pos].team == t:
			figures.append(state[pos])
	
	return figures

func get_figures_by_team(t: team) -> Array[Figure]:
	var figures: Array[Figure] = []
	for pos in state:
		if state[pos].team == t:
			figures.append(state[pos])
	
	return figures


func _on_marker_figure_move(marker: Variant) -> void:
	unhighlight_markers()
	if state.has(marker.board_position):
		state[marker.board_position].delete()
	selected_figure.move(marker)
	turn = team.Black


func _on_marker_figure_set(marker: Variant) -> void:
	emit_signal("_set_figure", marker)

func highlight_placeholder_markers(selected_card: FigureCard, distance: int) -> void:
	for i in markers:
		var highlight = markers[i].free_marker_highlight
		highlight.visible = !palace_positions.has(i) and !state.has(i) and \
		 i.y <=  distance and in_boundaries(i, selected_card)

	
func in_boundaries(pos : Vector2, card: FigureCard) -> bool:
	if card.type == Figure.Types.Elephant:
		return pos.y <= 4
	return true

func set_figure(type: Figure.Types, board_position: Vector2, group: String = "Magma", t: team = team.Red) -> void:
	var figure_scene : String = figure_scenes[type]
	var marker = markers[board_position]
	figure_scene = figure_scene.replace("{GROUP}", group)
	var figure = load(figure_scene).instantiate()
	figure.team = t
	figure.board = self
	add_child(figure)
	figure.global_position = marker.global_position
	figure.board_position = marker.board_position
	state[marker.board_position] = figure
	calculate_moves()
	unhighlight_markers()

func reset(move: int) -> void:
	delete_figures()
	unhighlight_markers()
	load_move(move)
	emit_signal("_reset")

func delete_figures():
	for i in state.keys():
		state[i].delete()
		state.erase(i)
