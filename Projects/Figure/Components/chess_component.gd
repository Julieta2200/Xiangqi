class_name ChessComponent extends Node

# chess value for current figure (need for the AI)
@export var value: float
@export var team : BoardV2.Teams

@export var figure_component: FigureComponent
@export var move_component: MoveComponent

var position: Vector2i :
	set(p):
		position = p
		var marker: BoardMarker = figure_component.board.markers[p]
		move_component.move_to_position(marker.global_position)

# Stores the movement boundaries for a figure, with the team as the key and the positions as a list of Vector2
var boundaries: Dictionary

func _ready() -> void:
	if figure_component.board:
		figure_component.board.set_figure(figure_component, position)

func show_moves():
	if !figure_component.board:
		return
	var available_moves: Array[Vector2i] = calculate_moves(figure_component.board.state, position)
	figure_component.board.show_move_markers(available_moves, figure_component)
	
func calculate_moves(state: Dictionary, current_position: Vector2i) -> Array[Vector2i]:
	return []

func in_boundaries(pos: Vector2i) -> bool:
	return pos.x >= boundaries[team].x.x and pos.x <= boundaries[team].x.y \
		and pos.y >= boundaries[team].y.x and pos.y <= boundaries[team].y.y

func move_or_capture(pos: Vector2i, state: Dictionary) -> bool:
	return !state.has(pos) || state[pos].team != team 
