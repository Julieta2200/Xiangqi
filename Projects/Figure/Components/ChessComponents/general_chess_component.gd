extends ChessComponent

var flying_pos: Array[Vector2i]
var flying_limits = {
		BoardV2.Teams.Red: {
			"position": 10,
			"direction": 1
		},
		BoardV2.Teams.Black: {
			"position": -1,
			"direction": -1
		},
	}
const directions: Array[Vector2i] = [
		Vector2i(0, 1),
		Vector2i(0, -1),
		Vector2i(-1, 0),
		Vector2i(1, 0)
	]

func _ready() -> void:
	super._ready()
	boundaries = {
		BoardV2.Teams.Red: {
			"y": Vector2i(0,2),
			"x": Vector2i(3,5)
		},
		BoardV2.Teams.Black: {
			"y": Vector2i(7,9),
			"x": Vector2i(3,5)
		},
	}
	
func calculate_moves(state: Dictionary, current_position: Vector2i) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	flying_pos = []
	for dir in directions:
		var new_pos = position + dir
		if in_boundaries(new_pos) and move_or_capture(new_pos,state):
			moves.append(new_pos)
	
	moves += flying(current_position, state)
	return moves

func flying(start_pos: Vector2i, state:Dictionary)-> Array[Vector2i]:
	var limit = flying_limits[team]
	for i in range(start_pos.y + limit.direction, limit.position , limit.direction):
		var new_pos = Vector2i(start_pos.x,i)
		if state.has(new_pos):
			if state[new_pos].type == figure_component.Types.GENERAL and state[new_pos].chess_component.team != team:
				flying_pos.append(new_pos)
			else: 
				break
	
	return flying_pos
