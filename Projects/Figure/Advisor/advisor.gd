extends Figure

@onready var red_sprite = load("res://Assets/Characters/Advisor/Raven.png")
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
		$Advisor.scale = Vector2(6.5,6.5)
		$mouse_entered_highlight.scale = Vector2(1.8,1.8)
		$Eye.position = Vector2(-50,-190)
		$mouse_entered_highlight.position = Vector2(-50,-6.6)
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
				
func get_moves(state: Dictionary, current_position: Vector2, state_hash: String = "") -> Array[Vector2]:
	if state_hash != "" and _move_hashes.has(state_hash):
		return _move_hashes[state_hash]
	
	var moves: Array[Vector2] = []
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) and move_or_capture(new_pos, state):
			if board.valid_future_state(current_position, new_pos, state):
				moves.append(new_pos)
	
	_move_hashes[state_hash] = moves
	return moves
