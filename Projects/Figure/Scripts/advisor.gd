extends Figure

var target_position: Vector2
const directions: Array[Vector2] = [
		Vector2(-1, -1),
		Vector2(1, -1),
		Vector2(-1, 1),
		Vector2(1, 1)
	]

func _ready():
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
				
func get_moves(state: Dictionary, current_position: Vector2) -> Array[Vector2]:
	var moves: Array[Vector2] = []
	for dir in directions:
		var new_pos = current_position + dir
		if in_boundaries(new_pos) and move_or_capture(new_pos, state):
			moves.append(new_pos)
	
	return moves

func animation(old_pos: Vector2, new_pos: Vector2)-> void:
	var direction = new_pos - old_pos
	if direction.y > 0 and direction.x > 0:
		$AnimatedSprite2D.play("walk_back_right")
	elif direction.y < 0 and direction.x > 0:
		$AnimatedSprite2D.play("walk_front_right")
	elif direction.y > 0 and direction.x < 0:
		$AnimatedSprite2D.play("walk_back_left")
	else:
		$AnimatedSprite2D.play("walk_front_left")
	
func  generate_run_tween(target_pos):
	$Sign/AnimationPlayer.play("left")
	target_position = target_pos

func set_pos():
	global_position = target_position
	super.finished_move()
