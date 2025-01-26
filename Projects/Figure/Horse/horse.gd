extends Figure

@onready var black_sprite = load("res://Assets/tmp/horse_black.png")
@onready var red_sprite = load("res://Assets/tmp/horse_red.png")

const directions: Array[Dictionary] = [
		{ "move": Vector2(-2, -1), "blocker": Vector2(-1, 0) },
		{ "move": Vector2(-2, 1), "blocker": Vector2(-1, 0) },
		{ "move": Vector2(2, -1), "blocker": Vector2(1, 0) },
		{ "move": Vector2(2, 1), "blocker": Vector2(1, 0) },
		{ "move": Vector2(-1, -2), "blocker": Vector2(0, -1) },
		{ "move": Vector2(1, -2), "blocker": Vector2(0, -1) },
		{ "move": Vector2(-1, 2), "blocker": Vector2(0, 1) },
		{ "move": Vector2(1, 2), "blocker": Vector2(0, 1) }
	]

func _ready():
	if team == Board.team.Red:
		$Horse.texture = red_sprite
	else:
		$Horse.texture = black_sprite
	boundaries = {
		Board.team.Red: {
			"y": Vector2(0,9),
			"x": Vector2(0,8)
		},
		Board.team.Black: {
			"y": Vector2(0,9),
			"x": Vector2(0,8)
		},
	}
				
func get_moves(state: Dictionary, current_position: Vector2) -> Array[Vector2]:
	var moves: Array[Vector2] = []
	
	for dir in directions:
		var new_pos = current_position + dir.move
		var blocker_pos = dir.blocker
		if in_boundaries(new_pos) and free_path(current_position, blocker_pos, state) and move_or_capture(new_pos, state):       
			if board.valid_future_state(current_position, new_pos, state):
				moves.append(new_pos)
	
	return moves
	
func free_path(current_position: Vector2, dir: Vector2, state: Dictionary) -> bool:
	return !state.has(current_position + dir)

