extends Level


func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(5,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(4,1)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.HORSE, Vector2i(1,9)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,6)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(2,8)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(3,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(4,8)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(5,9)),
	]
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new('Attack!', DialogSystem.CHARACTERS.Ashes)], true)

func check_game_over() -> bool:
	if super.check_game_over():
		return true
	if board.move_number > 7:
		ran_out_of_moves_dialog()
		return true

	return false

func ran_out_of_moves_dialog() -> void:
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new('We ran out of time!', DialogSystem.CHARACTERS.Advisor)], true)
	DialogSystem.connect("dialog_finished", _ran_out_of_moves_dialog_finished)

func _ran_out_of_moves_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _ran_out_of_moves_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _ran_out_of_moves_dialog_finished)
	_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
