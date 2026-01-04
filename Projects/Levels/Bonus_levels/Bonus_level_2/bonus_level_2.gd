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
	_disable_play()
	attack_dialog()

func attack_dialog() -> void:
	# this is the dialog when level is played for the first time
	if GameState.get_level_state(level_name) == LevelMarker.LevelState.Open \
	or GameState.get_level_state(level_name) == LevelMarker.LevelState.Closed:
		DialogSystem.start_dialog([
		DialogSystem.DialogText.new("BONUS_LEVEL_2_BEFORE_MOG", DialogSystem.CHARACTERS.Advisor),
		DialogSystem.DialogText.new("BONUS_LEVEL_2_BEFORE_ASHES", DialogSystem.CHARACTERS.Ashes)], true)
		DialogSystem.connect("dialog_finished", _enable_play)
		return

	if GameState.get_level_state(level_name) == LevelMarker.LevelState.Free:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("BONUS_LEVEL_2_FREE_1", DialogSystem.CHARACTERS.Advisor),
			DialogSystem.DialogText.new("BONUS_LEVEL_2_FREE_2", DialogSystem.CHARACTERS.Ashes)], true)
	else:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("BONUS_LEVEL_2_CLAIM_1", DialogSystem.CHARACTERS.Ashes)], true)

	DialogSystem.connect("dialog_finished", _enable_play)

func _enable_play():
	super._enable_play()
	if DialogSystem.is_connected("dialog_finished", _enable_play):
		DialogSystem.disconnect("dialog_finished", _enable_play)

func check_game_over() -> bool:
	if super.check_game_over():
		return true
	if board.move_number > 7:
		ran_out_of_moves_dialog()
		return true

	return false

func ran_out_of_moves_dialog() -> void:
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("BONUS_LEVEL_2_RAN_OUT_OF_TIME", DialogSystem.CHARACTERS.Jakat)], true)
	DialogSystem.connect("dialog_finished", _ran_out_of_moves_dialog_finished)

func _ran_out_of_moves_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _ran_out_of_moves_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _ran_out_of_moves_dialog_finished)
	_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)

func _on_game_over(win: BoardV2.GameOverResults, move_number: int):
	await get_tree().process_frame
	if win == BoardV2.GameOverResults.Win:
		gameplay_ui.objectives.complete_objectives(true)
		update_best_move_number(move_number)
		load_decision_dialog()
	else:
		gameplay_ui.objectives.complete_objectives(false)
		if board.move_number <= 7:
			DialogSystem.start_dialog([
				DialogSystem.DialogText.new("BONUS_LEVEL_2_LOSE", DialogSystem.CHARACTERS.Jakat)], true)
		DialogSystem.connect("dialog_finished", _lose_dialog_finished)

func _lose_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _lose_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _lose_dialog_finished)
	show_game_over_ui()

var _decision_option: Dictionary = {}

func load_decision_dialog() -> void:
	if GameState.get_level_state(level_name) == LevelMarker.LevelState.Captured:
		load_main_scene()
		return
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("BONUS_LEVEL_2_DECISION_JAKAT", DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new("", DialogSystem.CHARACTERS.Ashes, [
			{"text": "BONUS_LEVEL_2_DECISION_SET_FREE"}, {"text": "BONUS_LEVEL_2_DECISION_CLAIM"}])
	], true)
	DialogSystem.connect("decision_made", _on_decision_made)
	DialogSystem.connect("dialog_finished", _on_decision_dialog_finished)

func _on_decision_made(option: Dictionary) -> void:
	_decision_option = option

func _on_decision_dialog_finished() -> void:
	if DialogSystem.is_connected("decision_made", _on_decision_made):
		DialogSystem.disconnect("decision_made", _on_decision_made)
	if DialogSystem.is_connected("dialog_finished", _on_decision_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _on_decision_dialog_finished)
	
	if _decision_option.is_empty():
		return
	
	var follow_up_dialogs: Array[DialogSystem.DialogText] = []
	
	if _decision_option["text"] == "BONUS_LEVEL_2_DECISION_SET_FREE":
		GameState.set_ll_card(card)
		GameState.set_level_state(level_name, LevelMarker.LevelState.Free)
		follow_up_dialogs = [
			DialogSystem.DialogText.new("BONUS_LEVEL_2_WIN_SET_FREE", DialogSystem.CHARACTERS.Jakat)
		]
	else:
		GameState.set_level_state(level_name, LevelMarker.LevelState.Captured)
		GameState.remove_ll_card(card)
		GameState.add_orb()
		follow_up_dialogs = [
			DialogSystem.DialogText.new("BONUS_LEVEL_2_WIN_CLAIM", DialogSystem.CHARACTERS.Jakat)
		]
	
	_decision_option = {}
	DialogSystem.start_dialog(follow_up_dialogs, true)
	DialogSystem.connect("dialog_finished", _follow_up_dialog_finished)

func _follow_up_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _follow_up_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _follow_up_dialog_finished)
	load_main_scene()
