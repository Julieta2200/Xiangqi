extends Level


func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(3,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(5,9)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,7)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(3,7)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(5,7)),
	]
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("Don't go any further!", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("Mara...", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("Ashes, You will go back to the Limbo, and your advisors will be executed!", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("You are outnumbered, and how did you plan to stop us?", DialogSystem.CHARACTERS.Advisor),
		DialogSystem.DialogText.new("I didn't came here to fight you, Ashes...", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("Out of my way...", DialogSystem.CHARACTERS.Ashes),
	], true)
	_disable_play()
	DialogSystem.connect("dialog_finished", _enable_play)

func _on_board_game_over(win, move_number):
	await get_tree().process_frame
	if win:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("She's running away!", DialogSystem.CHARACTERS.Advisor),
			DialogSystem.DialogText.new("We will meet her soon enough.", DialogSystem.CHARACTERS.Ashes),
		], true)
		DialogSystem.connect("dialog_finished", _final_dialog_ended)
	else:
		super._on_board_game_over(win, move_number)
	
func _final_dialog_ended():
	if DialogSystem.is_connected("dialog_finished", _final_dialog_ended):
		DialogSystem.disconnect("dialog_finished", _final_dialog_ended)
	super._on_board_game_over(true, board.move_number)
