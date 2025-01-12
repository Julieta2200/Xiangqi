class_name Figure extends Node2D

@export var team : int
@export var type : Types

enum Types {General, Soldier}

var boundaries: Dictionary
var valid_moves: Array[Vector2] = []

var board_position : Vector2:
	set(p):
		%Board.state[board_position] = null
		board_position = p
		self.global_position = %Board.markers[board_position.y][board_position.x].global_position
		%Board.state[board_position] = self


func calculate_moves() -> void:
	pass
	
func in_boundaries(pos: Vector2) -> bool:
	return pos.x >= boundaries[team].x.x and pos.x <= boundaries[team].x.y \
		and pos.y >= boundaries[team].y.x and pos.y <= boundaries[team].y.y

func highlight_moves() -> void:
	for move in valid_moves:
		%Board.markers[move.y][move.x].highlight()

func _on_mouse_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") && %Board.turn == team:
		%Board.selected_figure = self
		highlight_moves()
	
func _on_area_2d_mouse_entered():
	$highlight.visible = true

func _on_area_2d_mouse_exited():
	$highlight.visible = false
