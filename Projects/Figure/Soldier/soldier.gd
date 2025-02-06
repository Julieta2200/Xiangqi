class_name Soldier extends Figure

@onready var red_sprite = load("res://Assets/Characters/Pawn/Fire pawn.png")
@onready var black_sprite = load("res://Assets/tmp/soldier_black.png")

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
		}
	}	


func get_moves(state: Dictionary, current_position: Vector2, state_hash: String = "") -> Array[Vector2]:
	if state_hash != "" and _move_hashes.has(state_hash):
		return _move_hashes[state_hash]
	
	var moves: Array[Vector2] = []
	
	var directions = []
	match team:
		Board.team.Red:
			directions.append(Vector2(0, 1))
			if current_position.y >= 5:
				value = 2
				directions += [Vector2.LEFT, Vector2.RIGHT]
		Board.team.Black:
			directions.append(Vector2(0, -1))
			if current_position.y <= 4:
				value = 2
				directions += [Vector2.LEFT, Vector2.RIGHT]
				
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) && move_or_capture(new_pos, state):
			if board.for_tutorial or board.valid_future_state(current_position, new_pos, state):
				moves.append(new_pos)
	
	_move_hashes[state_hash] = moves
	return moves
