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
# state is keeping current state of the position,
# key is the position and the value is the figure
# which is on that position.
var state : Dictionary

# selected_figure is the figure that was clicked and ready to be moved.
var selected_figure: Figure

# if false player cannot make moves or interact with figures
var can_move : bool = true

# figure_move_done emitted when move is complete
signal figure_move_done

# turn, when set is recalculating the moves
var turn: team = team.Red:
	set(t):
		turn = t
		calculate_moves()
		_on_turn_changed()

# Hook method called when turn changes, can be overridden by child classes
func _on_turn_changed():
	pass

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


func _ready():
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

func unhighlight_markers():
	for key in markers:
		markers[key].unhighlight()

# Calculates possible moves for the current team based on the current state of the board
func calculate_moves():
	var keys: Array = state.keys()
	for pos in keys:
		if state[pos].team == turn:
			state[pos].calculate_moves()

func get_generals(board_state: Dictionary) -> Dictionary:
	var generals: Dictionary
	for pos in board_state:
		if board_state[pos].type == Figure.Types.General:
			generals[board_state[pos].team] = pos
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

# Controls the figure's movement to the new marker, 
# deletes the figure at the old position, and unhighlight the hover effect
func _on_marker_figure_move(marker: Variant) -> void:
	unhighlight_markers()
	selected_figure.hover_unhighlight()
	if state.has(marker.board_position):
		state[marker.board_position].disappear_animation(selected_figure)
	
	selected_figure.move(marker)
	can_move = false




# Spawns and initializes a figure at the board, according to the given parameters
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

# Override this in child classes to implement different turn logic
func _on_figure_move_done():
	emit_signal("figure_move_done")

# Override this in child classes to implement different selection logic
func _on_figure_selected(_figure):
	pass

# Deletes all figures from the state
func delete_figures():
	for i in state.keys():
		state[i].delete()
		state.erase(i)
