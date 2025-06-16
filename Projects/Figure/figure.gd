class_name Figure extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var team : Board.team
@export var type : Types
@export var speed: float
@export var value: float
var deleted : bool
enum Types {General, Advisor, Soldier, Elephant, Chariot, Horse, Cannon}

# Stores the movement boundaries for a figure, with the team as the key and the positions as a list of Vector2
var boundaries: Dictionary

#Valid movement positions for the current step.
var valid_moves: Array[Vector2] = []

# Indicates whether the figure should respond to mouse hover at this moment
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
	#if state[pos].team != team :
		#state[pos]
		#return true
	return !state.has(pos) || state[pos].team != team 


func highlight_moves() -> void:
	for move in valid_moves:
		board.markers[move].highlight(board.state.has(move))

func _on_mouse_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") and active and mouse_can_hover and board.can_move:
		emit_signal("figure_selected", self)
		$hover/AnimationPlayer.play("RESET")
		$hover.show()
		mouse_can_hover = false
		
func _on_area_2d_mouse_entered():
	if team == board.turn and active and mouse_can_hover and board.can_move:
		$hover.show()
		$hover/AnimationPlayer.play("highlight")

func _on_area_2d_mouse_exited():
	if team == board.turn and active and mouse_can_hover and board.can_move:
		$hover/AnimationPlayer.play("unhighlight")

# Hide hover effect when another figure is selected or starts moving
func hover_unhighlight():
	$hover.hide()

# Hide valid movement positions while the figure is moving
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

#Delete the figure if it has been captured.
func delete():
	queue_free()

func disappear(attacker: Figure) -> void:
	play_directional_animation(board_position, attacker.board_position, "disappear")
	deleted = true
	

func move(marker):
	animation(board_position, marker.board_position)
	board_position = marker.board_position
	
	generate_run_tween(marker.global_position)

#Created and used a tween to move the figure from one point to another.
func generate_run_tween(target_pos):
	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 1.0/speed) 
	tween.finished.connect(finished_move)
	
func finished_move():
	mouse_can_hover = true
	emit_signal("move_done")

func animation(old_pos: Vector2, new_pos: Vector2) -> void:
	play_directional_animation(old_pos, new_pos, "walk")

func teleport():
	animated_sprite.play("teleport")

# Activates the inactive animation after the moving animation ends
func _on_figure_animation_finished():
	if !deleted:
		$AnimatedSprite2D.play("idle")
	else:
		delete()

# play any animation for any figure, used for cutscenes
func play_animation(animation: String) -> void:
	animated_sprite.play(animation)

func play_directional_animation(from: Vector2, to: Vector2, anim: String) -> void:
	var direction = to - from
	var animation_name := ""

	if direction.y > 0:
		animation_name = anim + "_back"
	elif direction.y < 0:
		animation_name = anim + "_front"
	elif direction.x > 0:
		animation_name = anim + "_right"
	else:
		animation_name = anim + "_left"

	play_animation(animation_name)
