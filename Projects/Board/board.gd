class_name Board extends Node

const board_rows = 10
const board_cols = 9
enum team {Red = 1, Black = 2}

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
var can_move : bool = true

signal figure_move_done
signal move_computer

var turn: team:
	set(t):
		turn = t
		calculate_moves()
		if turn == Board.team.Black:
			move_number += 1
			emit_signal("move_computer")

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
			markers[Vector2(j,i)].highlight_end.connect(_on_marker_highlight_end)

func _on_marker_highlight_end():
	can_move = true
	for key in markers:
		if markers[key].position_marker.visible:
			markers[key].position_marker_unhighlight()

func create_state(new_state: Dictionary) -> void:
	delete_figures()
	unhighlight_markers()
	turn = team.Red
	state = {}
	for key in new_state:
		set_figure(new_state[key].type, key,
		 new_state[key].group, new_state[key].team,
		 new_state[key].has("inactive"))
	
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

func computer_move(pos: Vector2, new_pos: Vector2) -> bool:
	unhighlight_markers()
	if !state.has(pos) or state[pos].team != turn:
		return false
	if state.has(new_pos):
		state[new_pos].delete()
	state[pos].move(markers[new_pos])
	generate_save_state()
	return true

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
	selected_figure.hover_unhighlight()
	if state.has(marker.board_position):
		state[marker.board_position].delete()
	selected_figure.move(marker)
	can_move = false


func _on_marker_figure_set(marker: Variant) -> void:
	emit_signal("_set_figure", marker)

func highlight_placeholder_markers(selected_card: FigureCard, distance: int) -> void:
	can_move = false
	var position_markers : Dictionary
	for i in markers:
		var highlight = markers[i].position_marker
		highlight.visible = !palace_positions.has(i) and !state.has(i) and \
		 i.y <=  distance and in_boundaries(i, selected_card) 
		if highlight.visible:
			position_markers[i] = markers[i]
	
	for i in position_markers:
		position_markers[i].horizontal_line.visible = position_markers.has(Vector2(i.x+1,i.y))
		position_markers[i].vertical_line.visible = position_markers.has(Vector2(i.x,i.y+1))

func in_boundaries(pos : Vector2, card: FigureCard) -> bool:
	if card.type == Figure.Types.Elephant:
		return pos.y <= 4
	return true

func set_figure(type: Figure.Types, board_position: Vector2, group: String = "Magma", t: team = team.Red, inactive: bool = false, teleport: bool = false) -> void:
	var figure_scene : String = figure_scenes[type]
	var marker: BoardMarker = markers[board_position]
	figure_scene = figure_scene.replace("{GROUP}", group)
	var figure: Figure = load(figure_scene).instantiate()
	figure.team = t
	figure.board = self
	add_child(figure)
	figure.global_position = marker.global_position
	figure.board_position = marker.board_position
	figure.active = !inactive
	figure.move_done.connect(_on_figure_move_done)
	state[marker.board_position] = figure
	calculate_moves()
	unhighlight_markers()
	if teleport:
		figure.teleport()
		marker.position_marker_light(group)
	figure.figure_selected.connect(_on_figure_selected)

func _on_figure_move_done():
	if turn == team.Black:
		turn = team.Red
		can_move = true
	else:
		turn = team.Black
		emit_signal("figure_move_done")

func _on_figure_selected(figure):
	if figure.team == Board.team.Red and can_move:
		if selected_figure != null:
			selected_figure.delete_highlight()
			markers[selected_figure.board_position].unhighlight()
		selected_figure = figure
		selected_figure.highlight_moves()
	
func reset(move: int) -> void:
	delete_figures()
	unhighlight_markers()
	load_move(move)

func delete_figures():
	for i in state.keys():
		state[i].delete()
		state.erase(i)
