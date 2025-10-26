extends Level


func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(4,1)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(5,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(4,8)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(4,5)),
	]
	board.initialize_position(state)
	
func check_game_over() -> bool:
	if super.check_game_over():
		return true
	var horse: Array
	for i in board.get_figures(BoardV2.Teams.Black):
		if i.type == FigureComponent.Types.HORSE:
			horse.append(i)
	if horse.size() < 1:
		_on_game_over(BoardV2.GameOverResults.Win, board.move_number)
		return true
	if board.move_number >= 8:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	return false
