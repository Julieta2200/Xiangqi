class_name Figure extends Node2D

@export var team : Board.team
@export var type : Types
@export var value: float

enum Types {General, Advisor, Soldier, Elephant}

var boundaries: Dictionary
var valid_moves: Array[Vector2] = []

@onready var board: Board

var board_position : Vector2:
	set(p):
		board.state[board_position] = null
		board_position = p
		self.global_position = board.markers[board_position].global_position
		board.state[board_position] = self

var active: bool =  true


func calculate_moves() -> void:
	valid_moves = get_moves(board.state, board_position)
	
func get_moves(state: Dictionary, current_position: Vector2) -> Array[Vector2]:
	return []

func in_boundaries(pos: Vector2) -> bool:
	return pos.x >= boundaries[team].x.x and pos.x <= boundaries[team].x.y \
		and pos.y >= boundaries[team].y.x and pos.y <= boundaries[team].y.y

func move_or_capture(pos: Vector2, state: Dictionary) -> bool:
	return state[pos] == null || state[pos].team != team 


func highlight_moves() -> void:
	for move in valid_moves:
		board.markers[move].highlight()

func _on_mouse_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") and board.turn == team and team == Board.team.Red and active:
		if board.selected_figure != null:
			board.selected_figure.delete_highlight()
		board.selected_figure = self
		highlight_moves()
	
func _on_area_2d_mouse_entered():
	if team == board.turn:
		$highlight.visible = true

func _on_area_2d_mouse_exited():
	$highlight.visible = false

func delete_highlight():
	for move in valid_moves:
		board.markers[move].unhighlight()

func delete():
	queue_free()
