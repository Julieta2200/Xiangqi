class_name General extends Figure

@onready var red_sprite = load("res://Assets/Characters/Ashes/Mini_Ashes/Ashes_mini_back.png")
@onready var black_sprite = load("res://Assets/tmp/general_black.png")

const directions: Array[Vector2] = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(-1, 0),
		Vector2(1, 0)
	]

func _ready():
	if team == Board.team.Red:
		$General.texture = red_sprite
	else:
		$General.scale = Vector2(0.25,0.25)
		$General.texture = black_sprite
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


func get_moves(state: Dictionary, current_position: Vector2, state_hash: String = "") -> Array[Vector2]:
	if state_hash != "" and _move_hashes.has(state_hash):
		return _move_hashes[state_hash]
		
	var moves: Array[Vector2] = []
	
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) and move_or_capture(new_pos,state):
			if board.for_tutorial or board.valid_future_state(current_position, new_pos, state):
				moves.append(new_pos)
		
	_move_hashes[state_hash] = moves
	return moves
