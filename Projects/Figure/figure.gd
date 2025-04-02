class_name Figure extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var team : Board.team
@export var type : Types
@export var value: float
@export var speed: float
var position_delta : float = 0.5

enum Types {General, Advisor, Soldier, Elephant, Chariot, Horse, Cannon}

var boundaries: Dictionary
var valid_moves: Array[Vector2] = []
var mouse_can_hover: bool = true
@onready var board: Board


var board_position : Vector2 = Vector2(-1,-1):
	set(p):
		board.state.erase(board_position)
		board_position = p
		board.state[board_position] = self

	
var active: bool =  true

signal figure_selected(figure: Figure)
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
		board.markers[move].highlight(board.state.has(move))

func _on_mouse_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") and active:
		emit_signal("figure_selected", self)
		$hover.show()
		mouse_can_hover = false
		
func _on_area_2d_mouse_entered():
	if team == board.turn and active and mouse_can_hover:
		$hover.show()
		$hover/AnimationPlayer.play("highlight")

func _on_area_2d_mouse_exited():
	if team == board.turn and active and mouse_can_hover:
		$hover/AnimationPlayer.play("unhighlight")

func hover_unhighlight():
	$hover.hide()

func delete_highlight():
	hover_unhighlight()
	mouse_can_hover = true
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
	animation(board_position, marker.board_position)
	board_position = marker.board_position

	var tween = create_tween()
	tween.tween_property(self, "position", marker.global_position, 1.0/speed)
	
	tween.finished.connect(finished_move)

func finished_move():
	mouse_can_hover = true
	$AnimatedSprite2D.play("idle")
	emit_signal("move_done")

func animation(old_pos: Vector2, new_pos: Vector2)-> void:
	if (old_pos - new_pos).y < 0:
		$AnimatedSprite2D.play("walk_back")
	else:
		$AnimatedSprite2D.play("walk_front")

func teleport():
	animated_sprite.play("teleport")
