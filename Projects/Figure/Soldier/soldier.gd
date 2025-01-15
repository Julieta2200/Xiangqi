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
			"y": Vector2(0, 9),
			"x": Vector2(0, 8)
		},
		Board.team.Black: {
			"y": Vector2(0, 9),
			"x": Vector2(0, 8)
		},
	}

func calculate_moves() -> void:
	valid_moves = []
	
	var directions = []
	match team:
		Board.team.Red:
			directions.append(Vector2(0, 1))
			if board_position.y >= 5:
				directions += [Vector2.LEFT, Vector2.RIGHT]
		Board.team.Black:
			directions.append(Vector2(0, -1))
			if board_position.y <= 4:
				directions += [Vector2.LEFT, Vector2.RIGHT]
				
	for dir in directions:
		var new_pos = board_position + dir
		if in_boundaries(new_pos) && move_or_capture(new_pos):
			if %Board.valid_state(board_position, new_pos):
				valid_moves.append(new_pos)
