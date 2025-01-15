extends Node2D


func _ready():
	$General.board_position = Vector2(3,0)
	$General2.board_position = Vector2(3, 7)
	$Advisor.board_position = Vector2(3,2)
	$Advisor2.board_position = Vector2(3,9)
	$Soldier2.board_position = Vector2(3,5)
	$Soldier.board_position = Vector2(5,3)
	%Board.calculate_moves()
