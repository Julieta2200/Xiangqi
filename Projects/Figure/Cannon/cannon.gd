extends Figure

@onready var red_sprite = load("res://Assets/tmp/cannon_red.png")
@onready var black_sprite = load("res://Assets/tmp/cannon_black.png")

const directions: Array[Vector2] = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(-1, 0),
		Vector2(1, 0)
	]

func _ready():
	if team == Board.team.Red:
		$Cannon.texture = red_sprite
	else:
		$Cannon.texture = black_sprite
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
		var new_pos = current_position + dir
		var have_anchor: bool = false
		while in_boundaries(new_pos):
			if state[new_pos] == null and !have_anchor:
				if board.valid_future_state(board_position, new_pos, state):
					moves.append(new_pos)
			elif !have_anchor:
				have_anchor = true
			elif state[new_pos] != null:
				if state[new_pos].team != team:
					if board.valid_future_state(board_position, new_pos, state):
						moves.append(new_pos)
				break
			new_pos += dir
	
	return moves
