class_name Figure extends Node2D

@export var team : Board.team
@export var type : Types
@export var value: float
var position_delta : float = 0.5

#@onready var highlight = $Eye

enum Types {General, Advisor, Soldier, Elephant, Chariot, Horse, Cannon}

var boundaries: Dictionary
var valid_moves: Array[Vector2] = []

@onready var board: Board

var board_position : Vector2 = Vector2(-1,-1):
	set(p):
		board.state.erase(board_position)
		board_position = p
		board.state[board_position] = self

	
var active: bool =  true

signal move_done

func calculate_moves() -> void:
	valid_moves = get_moves(board.state, board_position)
	
func get_moves(state: Dictionary, current_position: Vector2) -> Array[Vector2]:
	return []

func in_boundaries(pos: Vector2) -> bool:
	return pos.x >= boundaries[team].x.x and pos.x <= boundaries[team].x.y \
		and pos.y >= boundaries[team].y.x and pos.y <= boundaries[team].y.y

func move_or_capture(pos: Vector2, state: Dictionary) -> bool:
	return !state.has(pos) || state[pos].team != team 


func highlight_moves() -> void:
	for move in valid_moves:
		board.markers[move].highlight()
		if board.state.has(move):
			board.markers[move].selected_highlight.visible = true

func _on_mouse_event(viewport, event, shape_idx):
	if board != null:
		if Input.is_action_pressed("click") and board.turn == team and team == Board.team.Red and active:
			if board.selected_figure != null:
				board.selected_figure.delete_highlight()
	#			board.selected_figure.highlight.visible = false
			board.selected_figure = self
	#		highlight.visible = true
			highlight_moves()
	
func _on_area_2d_mouse_entered():
	if board != null:
		if team == board.turn:
			$mouse_entered_highlight.visible = true

func _on_area_2d_mouse_exited():
	if board != null:
		$mouse_entered_highlight.visible = false

func delete_highlight():
	for move in valid_moves:
		board.markers[move].unhighlight()

func calculate_value(state: Dictionary, current_position: Vector2):
	var v: float = value
	v += 0.3*v*mobility_factor(state, current_position)
	if team == Board.team.Black:
		v = -v
	
	return v

func mobility_factor(state: Dictionary, current_position: Vector2) -> float:
	return 1

func delete():
	queue_free()


func move(marker):
	board.markers[board_position].trajectory_highlight()
	board_position = marker.board_position
	animation(marker.global_position)

	var tween = create_tween()
	tween.tween_property(self, "position", marker.global_position, 2)
	
	tween.finished.connect(finished_move)

func finished_move():
	$AnimatedSprite2D.play("idle")
	emit_signal("move_done")

func animation(pos)-> void:
	if team == Board.team.Red:
		if (pos - global_position).y > 0:
			$AnimatedSprite2D.play("walk_back")
		else:
			$AnimatedSprite2D.play("walk_front")
	else:
		if (pos - global_position).y < 0:
			$AnimatedSprite2D.play("walk_back")
		else:
			$AnimatedSprite2D.play("walk_front")
