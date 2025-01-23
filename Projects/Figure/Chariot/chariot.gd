extends Figure

@onready var red_sprite = load("res://Assets/tmp/chariot_red.png")
@onready var black_sprite = load("res://Assets/tmp/chariot_black.png")

const directions: Array[Vector2] = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(-1, 0),
		Vector2(1, 0)
	]

func _ready():
	if team == Board.team.Red:
		$Chariot.texture = red_sprite
	else:
		$Chariot.texture = black_sprite
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
		while in_boundaries(new_pos):
			if state[new_pos] == null:
				if board.valid_future_state(board_position, new_pos, state):
					moves.append(new_pos)
			else:
				if state[new_pos].team != team:
					if board.valid_future_state(board_position, new_pos, state):
						moves.append(new_pos)
				break
			new_pos += dir
	
	return moves
