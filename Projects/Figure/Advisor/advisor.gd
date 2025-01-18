extends Figure

@onready var red_sprite = load("res://Assets/tmp/advisor_red.png")
@onready var black_sprite = load("res://Assets/tmp/advisor.png")

const directions: Array[Vector2] = [
		Vector2(-1, -1),
		Vector2(1, -1),
		Vector2(-1, 1),
		Vector2(1, 1)
	]

func _ready():
	if team == Board.team.Red:
		$Advisor.texture = red_sprite
	else:
		$Advisor.texture = black_sprite
	boundaries = {
		Board.team.Red: {
			"y": Vector2(0,2),
			"x": Vector2(3,5)
		},
		Board.team.Black: {
			"y": Vector2(7,9),
			"x": Vector2(3,5)
		},
	}
func calculate_moves() -> void:
	valid_moves = []
	for dir in directions:
		var new_pos = board_position + dir
		if in_boundaries(new_pos) and move_or_capture(new_pos):
			if board.valid_state(board_position, new_pos):
				valid_moves.append(new_pos)
				
