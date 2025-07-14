class_name AI extends Node

@export var board: BoardV2

func _ready() -> void:
	randomize()

func get_figures() -> Array[FigureComponent]:
	return board.get_figures(BoardV2.Teams.Black)
	
func make_move() -> bool:
	var figures: Array[FigureComponent] = get_figures()
	var possible_moves: Array[Dictionary] = []
	for figure in figures:
		var moves: Array[Vector2i] = figure.chess_component.get_moves()
		for move in moves:
			possible_moves.append({
				"start": figure.chess_component.position,
				"end": move
			})
	if possible_moves.size() == 0:
		return false
	
	var move: Dictionary = possible_moves[randi() % possible_moves.size()]
	board.move_figure_AI(move)
	return true
