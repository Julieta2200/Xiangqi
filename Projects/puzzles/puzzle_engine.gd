extends ComputerEngine

@onready var board: BoardStory = %Board

func make_move() -> void:
	match board.move_number:
		1:
			board.state[Vector2(3,9)].visible = false
			%Board.computer_move(Vector2(3,9), Vector2(4,8))
			board.set_figure(Figure.Types.Advisor, Vector2(4,8), "Cloud", Board.team.Black)
		2:
			board.state[Vector2(4,8)].visible = false
			%Board.computer_move(Vector2(4,8), Vector2(5,7))
			board.set_figure(Figure.Types.Advisor, Vector2(5,7), "Cloud", Board.team.Black)
		3:
			board.state[Vector2(5,9)].visible = false
			%Board.computer_move(Vector2(5,9), Vector2(4,8))
			board.set_figure(Figure.Types.Advisor, Vector2(4,8), "Cloud", Board.team.Black)
		4:
			board.state[Vector2(4,8)].visible = false
			%Board.computer_move(Vector2(4,8), Vector2(3,7))
			board.set_figure(Figure.Types.Advisor, Vector2(3,7), "Cloud", Board.team.Black)
		5:
			board.state[Vector2(4,9)].visible = false
			%Board.computer_move(Vector2(4,9), Vector2(5,9))
			board.set_figure(Figure.Types.Advisor, Vector2(5,9), "Cloud", Board.team.Black)
		6:
			var texts: Array[TextBlock] 
			texts = [TextBlock.new("You won!","Advisor", "Sprite")]
			%Dialog.appear(texts)
