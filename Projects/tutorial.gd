extends Node2D


func _ready():
	$GeneralRed.board_position = Vector2(4,1)
	$GeneralBlack.board_position = Vector2(4, 9)
	$AdvisorRed1.board_position = Vector2(3,0)
	$AdvisorRed2.board_position = Vector2(5,0)
	$AdvisorBlack1.board_position = Vector2(3,9)
	$AdvisorBlack2.board_position = Vector2(5,9)
	$SoldierBlack1.board_position = Vector2(4,2)
	$SoldierRed1.board_position = Vector2(5,3)
	%Board.calculate_moves()
