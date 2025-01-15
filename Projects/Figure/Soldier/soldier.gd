extends Figure

@onready var red_sprite = load("res://Assets/soldier_red.png")
@onready var black_sprite = load("res://Assets/soldier_black.png")


func _ready():
	if team == Board.team.Red:
		$Soldier.texture = red_sprite
	else:
		$Soldier.texture = black_sprite
		
	boundaries = {
		Board.team.Red: {
			"x": Vector2(0, 9),
			"y": Vector2(0, 8)
		},
		Board.team.Black: {
			"x": Vector2(0, 9),
			"y": Vector2(0, 8)
		},
	}

func calculate_moves() -> void:
	valid_moves = []
	
	var directions = []
	match team:
		Board.team.Red:
			directions.append(Vector2(1, 0))
			if board_position.x >= 5:
				directions += [Vector2(0, -1), Vector2(0, 1)]
		Board.team.Black:
			directions.append(Vector2(-1, 0))
			if board_position.x <= 4:
				directions += [Vector2(0, -1), Vector2(0, 1)]

	for dir in directions:
		var new_pos = board_position + dir
		if in_boundaries(new_pos) && (%Board.state[new_pos] == null or %Board.state[new_pos].team != team):
			if %Board.valid_state(board_position, new_pos):
				valid_moves.append(new_pos)
