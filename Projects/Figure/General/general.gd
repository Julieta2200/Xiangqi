extends Figure

@onready var red_sprite = load("res://Assets/general.png")
@onready var black_sprite = load("res://Assets/general_black.png")

func _ready():
	if team == 1:
		$General.texture = red_sprite
	else:
		$General.texture = black_sprite

func available_moves() -> Array:
	var moves = []
	var palace_min_row
	var palace_max_row
	var palace_min_col = 3
	var palace_max_col = 5
	if team == 1:
		palace_min_row = 0
		palace_max_row = 2
	else:
		palace_min_row = 7
		palace_max_row = 9

	var directions = [
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(-1, 0),
		Vector2(1, 0) 
	]

	for dir in directions:
		var new_pos = board_position + dir
		if new_pos.x >= palace_min_row and new_pos.x <= palace_max_row \
		and new_pos.y >= palace_min_col and new_pos.y <= palace_max_col:
			if %Board.state[new_pos.x][new_pos.y] == null:
				if not generals_facing_each_other(new_pos):
					%Board.markers[new_pos.x][new_pos.y].highlight.visible = true
					moves.append(new_pos)

	return moves

func generals_facing_each_other(new_pos: Vector2) -> bool:
	var other_general_pos: Vector2 = find_other_general()
	if other_general_pos == Vector2(-1, -1):
		return false
	
	if other_general_pos.y == new_pos.y:
		var min_x = min(new_pos.x, other_general_pos.x)
		var max_x = max(new_pos.x, other_general_pos.x)
		
		for x in range(min_x + 1, max_x):
			if %Board.state[x][new_pos.y] != null:
				return false 
		return true
	
	return false


func find_other_general() -> Vector2:
	for row in range(%Board.board_rows):
		for col in range(%Board.board_cols):
			var figure = %Board.state[row][col]
			if figure != null && figure.type == %Board.figures_type.General \
			&& figure.team != self.team:
				return Vector2(row, col)

	return Vector2(-1, -1)



func _on_area_2d_mouse_entered():
	$highlight.visible = true


func _on_area_2d_mouse_exited():
	$highlight.visible = false


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click") && %Board.player == team:
		%Board.select_figure = self
		available_moves()
