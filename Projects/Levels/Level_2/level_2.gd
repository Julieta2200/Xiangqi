extends Level

@onready var blocking_panel: Control = $GameplayUI/BlockingPanel
@onready var hints: Array[HintBubble] = [
	$GameplayUI/Hints/Horses,
	$GameplayUI/Hints/Elephants,
]

var _hint_index: int = 0

func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(4,1)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(5,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(4,8)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(5,5)),
	]
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("LEVEL_2_DIALOG_1", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("LEVEL_2_DIALOG_2", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("LEVEL_2_DIALOG_3", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("LEVEL_2_DIALOG_4", DialogSystem.CHARACTERS.Mara),
	], true)
	_disable_play()
	DialogSystem.connect("dialog_finished", _enable_play)
	gameplay_ui.garrison.update_cards(gameplay_ui.power_meter.energy)

	
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
	var advisors: Array[FigureComponent] = board.get_figures(BoardV2.Teams.Red).filter(func(f): return f.type == FigureComponent.Types.ADVISOR)
	if advisors.size() < 2:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	var generals: Array[FigureComponent] = board.get_figures(BoardV2.Teams.Red).filter(func(f): return f.type == FigureComponent.Types.GENERAL)
	if generals.size() < 1:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	return false

func _enable_play():
	super._enable_play()
	if GameState.state["first_horse_introduction"]:
		blocking_panel.show()
		run_hint_system()

func run_hint_system() -> void:
	if _hint_index >= hints.size():
		GameState.state["first_horse_introduction"] = false
		GameState.save_game()
		blocking_panel.hide()
		return
	AudioManager.play_sound("dialog_box")
	hints[_hint_index].show()
	_hint_index += 1

func _horses_hint_shown() -> void:
	var horses: Array[FigureComponent] = board.get_figures_by_type(FigureComponent.Types.HORSE)
	if hints[0].visible:
		for horse in horses:
			horse.shader_component.hint_highlight()
	else:
		for horse in horses:
			horse.shader_component.hint_unhighlight()

func _on_game_over(win: BoardV2.GameOverResults, move_number: int):
	await get_tree().process_frame
	if win == BoardV2.GameOverResults.Win:
		gameplay_ui.objectives.complete_objectives(true)
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("LEVEL_2_VICTORY_DIALOG_1", DialogSystem.CHARACTERS.Ashes),
			DialogSystem.DialogText.new("LEVEL_2_VICTORY_DIALOG_2", DialogSystem.CHARACTERS.Mara),
			DialogSystem.DialogText.new("LEVEL_2_VICTORY_DIALOG_3", DialogSystem.CHARACTERS.Ashes),
		], true)
	else:
		gameplay_ui.objectives.complete_objectives(false)
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("LEVEL_2_DEFEAT_DIALOG", DialogSystem.CHARACTERS.Mara)
		],true)
	
	DialogSystem.connect("dialog_finished", _final_dialog_ended.bind(win))

func _final_dialog_ended(win):
	if DialogSystem.is_connected("dialog_finished", _final_dialog_ended):
		DialogSystem.disconnect("dialog_finished", _final_dialog_ended)
	super._on_game_over(win, board.move_number)
