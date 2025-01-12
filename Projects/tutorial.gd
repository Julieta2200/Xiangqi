extends Node2D


func _ready():
	$General.board_position = Vector2(3,0)
	$General2.board_position = Vector2(4,7)
	%Board.calculate_moves()
