class_name BoardV2 extends Node2D

const board_rows = 10
const board_cols = 9
enum Teams {Red = 1, Black = 2}
enum Kingdoms {MAGMA = 1, CLOUD = 2}

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
var scenes: Dictionary = {
	Kingdoms.MAGMA: {
		FigureComponent.Types.SOLDIER: load("res://Projects/Figure/V2/Magma/Soldier/Soldier.tscn")
	},
	Kingdoms.CLOUD: {
		FigureComponent.Types.SOLDIER: load("res://Projects/Figure/V2/Cloud/Soldier/Soldier.tscn")
	}
}

@export var ai: AI
var markers : Dictionary
var turn: Teams = Teams.Red :
	set(t):
		turn = t
		activate_reds(turn == Teams.Red)

var state: Dictionary
# For which figure the markers are currently highlighted
var _selected_figure: FigureComponent

func _ready() -> void:
	initialize_markers()
	initialize_position()
	
func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			var marker: BoardMarker = $Markers.get_child(i).get_child(j)
			markers[Vector2i(j,i)] = marker
			markers[Vector2i(j,i)].board_position = Vector2i(j,i)
			marker.figure_move.connect(move_figure)

func initialize_position():
	var magma_soldier: FigureComponent = scenes[Kingdoms.MAGMA][FigureComponent.Types.SOLDIER].instantiate()
	magma_soldier.board = self
	magma_soldier.chess_component.position = Vector2i(1,1)
	add_child(magma_soldier)
	var cloud_soldier: FigureComponent = scenes[Kingdoms.CLOUD][FigureComponent.Types.SOLDIER].instantiate()
	cloud_soldier.board = self
	cloud_soldier.chess_component.position = Vector2i(6,8)
	add_child(cloud_soldier)

func show_move_markers(positions: Array[Vector2i], figure: FigureComponent) -> void:
	_selected_figure = figure
	for pos in positions:
		var marker: BoardMarker = markers[pos]
		marker.highlight(BoardMarker.Highlights.MOVE)

func set_figure(figure: FigureComponent, pos: Vector2i) -> void:
	state[pos] = figure
	figure.global_position = markers[pos].global_position

func move_figure(marker: BoardMarker) -> void:
	clear_markers()
	state.erase(_selected_figure.chess_component.position)
	state[marker.board_position] = _selected_figure
	_selected_figure.chess_component.change_position(marker.board_position)
	turn = Teams.Black

func clear_markers() -> void:
	for pos in markers:
		var m: BoardMarker = markers[pos]
		m.unhighlight()

func activate_reds(result: bool) -> void:
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team == Teams.Red:
			figure.ui_component.active = result
