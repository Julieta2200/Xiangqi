extends Node2D


func _ready():
	$General.board_position = Vector2(0,3)
	$General2.board_position = Vector2(7,3)
	$Advisor.board_position = Vector2(1,3)
	$Advisor2.board_position = Vector2(8,3)
	$Soldier.board_position = Vector2(3,5)
	$Soldier2.board_position = Vector2(5,3)
	%Board.calculate_moves()
