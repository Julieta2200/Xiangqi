extends Level

@onready var ai: AIV2 = $AI
@onready var blocking_panel: Control = $GameplayUI/BlockingPanel
@onready var hints: Array[HintBubble] = [
	$GameplayUI/Hints/Chariots,
	$GameplayUI/Hints/Cannons,
]

var _hint_index: int = 0

func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(4,8)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(3,9)),
		# State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ELEPHANT, Vector2i(4,7)),
		# State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(1,7)),
		# State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(7,7)),
	]
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("LEVEL_3_DIALOG_1", DialogSystem.CHARACTERS.Advisor),
		DialogSystem.DialogText.new("LEVEL_3_DIALOG_2", DialogSystem.CHARACTERS.Ashes),
	], true)
	_disable_play()
	DialogSystem.connect("dialog_finished", _enable_play)
	
func _enable_play():
	super._enable_play()
	if GameState.state["first_chariot_introduction"]:
		blocking_panel.show()
		run_hint_system()

func run_hint_system() -> void:
	if _hint_index >= hints.size():
		GameState.state["first_chariot_introduction"] = false
		GameState.save_game()
		blocking_panel.hide()
		return
	AudioManager.play_sound("dialog_box")
	hints[_hint_index].show()
	_hint_index += 1


func _on_board_move_done() -> void:
	if ai._special_used:
		return
	var red_figures: Array[FigureComponent] = board.get_figures(BoardV2.Teams.Red).filter(func(f): return f.chess_component.position.y > 4)
	if red_figures.size() > 0:
		ai.script_use_special = true
		blocking_panel.show()
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("LEVEL_3_AMBUSH_DIALOG_1", DialogSystem.CHARACTERS.Advisor),
			DialogSystem.DialogText.new("LEVEL_3_AMBUSH_DIALOG_2", DialogSystem.CHARACTERS.Advisor),
			DialogSystem.DialogText.new("LEVEL_3_AMBUSH_DIALOG_3", DialogSystem.CHARACTERS.Ashes),
			DialogSystem.DialogText.new("LEVEL_3_AMBUSH_DIALOG_4", DialogSystem.CHARACTERS.Ashes),
			DialogSystem.DialogText.new("LEVEL_3_AMBUSH_DIALOG_5", DialogSystem.CHARACTERS.Mara),
			DialogSystem.DialogText.new("LEVEL_3_AMBUSH_DIALOG_6", DialogSystem.CHARACTERS.Advisor),
			DialogSystem.DialogText.new("LEVEL_3_AMBUSH_DIALOG_7", DialogSystem.CHARACTERS.Ashes),
		], true)
		DialogSystem.connect("dialog_finished", _part_2_start)
		match red_figures[0].chess_component.position:
			Vector2i(4,7):
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.ELEPHANT, Vector2i(2,9))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(1,7))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(7,7))
			Vector2i(1,7):
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.ELEPHANT, Vector2i(4,7))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(2,9))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(7,7))
			Vector2i(7,7):
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.ELEPHANT, Vector2i(4,7))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(1,7))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(8,9))
			_:
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.ELEPHANT, Vector2i(4,7))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(1,7))
				board.instantiate_figure(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(7,7))
		

func _part_2_start() -> void:
	DialogSystem.disconnect("dialog_finished", _part_2_start)
	blocking_panel.hide()

func _on_game_over(win: BoardV2.GameOverResults, move_number: int):
	await get_tree().process_frame
	if win == BoardV2.GameOverResults.Win:
		gameplay_ui.objectives.complete_objectives(true)
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("LEVEL_3_VICTORY_DIALOG_1", DialogSystem.CHARACTERS.Mara),
			DialogSystem.DialogText.new("LEVEL_3_VICTORY_DIALOG_2", DialogSystem.CHARACTERS.Ashes),
		], true)
	else:
		gameplay_ui.objectives.complete_objectives(false)
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("LEVEL_3_DEFEAT_DIALOG", DialogSystem.CHARACTERS.Mara)
		],true)
	
	DialogSystem.connect("dialog_finished", _final_dialog_ended.bind(win))

func _final_dialog_ended(win):
	if DialogSystem.is_connected("dialog_finished", _final_dialog_ended):
		DialogSystem.disconnect("dialog_finished", _final_dialog_ended)
	super._on_game_over(win, board.move_number)
