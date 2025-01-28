extends Figure

@onready var black_sprite = load("res://Assets/tmp/elephant_black.png")
@onready var red_sprite = load("res://Assets/tmp/elephant_red.png")

const directions: Array[Vector2] = [
		Vector2(-2, -2),
		Vector2(2, -2),
		Vector2(-2, 2),
		Vector2(2, 2)
	]

func _ready():
	if team == Board.team.Red:
		$Elephant.texture = red_sprite
	else:
		$Elephant.texture = black_sprite
	boundaries = {
		Board.team.Red: {
			"y": Vector2(0,4),
			"x": Vector2(0,8)
		},
		Board.team.Black: {
			"y": Vector2(5,9),
			"x": Vector2(0,8)
		},
	}
				
func get_moves(state: Dictionary, current_position: Vector2, state_hash: String = "") -> Array[Vector2]:
	if state_hash != "" and _move_hashes.has(state_hash):
		return _move_hashes[state_hash]
	
	var moves: Array[Vector2] = []
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) and free_path(current_position, dir/2, state) and move_or_capture(new_pos, state):
			if board.valid_future_state(current_position, new_pos, state):
				moves.append(new_pos)
	
	_move_hashes[state_hash] = moves
	return moves

func free_path(current_position: Vector2, dir: Vector2, state: Dictionary) -> bool:
	return !state.has(current_position+dir)
