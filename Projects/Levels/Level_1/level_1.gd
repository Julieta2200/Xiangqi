extends Level

@onready var blocking_panel: Control = $GameplayUI/BlockingPanel
@onready var hints: Array[HintBubble] = [
	$GameplayUI/Hints/HintBubble,
	$GameplayUI/Hints/HintBubble2,
	$GameplayUI/Hints/HintBubble4,
	$GameplayUI/Hints/HintBubble3,
]
@onready var palace_light: PointLight2D = $Board/PalaceLight

var _hint_index: int = 0

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
		DialogSystem.DialogText.new("Stop right there.", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("Mara...", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("Ashes, I’m sorry, but you have to go back to the Limbo.", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("Make me…", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("Capture him!", DialogSystem.CHARACTERS.Mara),
	], true)
	_disable_play()
	DialogSystem.connect("dialog_finished", _enable_play)
	gameplay_ui.garrison.update_cards(gameplay_ui.power_meter.energy)

func _on_board_game_over(win, move_number):
	await get_tree().process_frame
	if win:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("She’s getting away!", DialogSystem.CHARACTERS.Advisor),
			DialogSystem.DialogText.new("Should we go after her?", DialogSystem.CHARACTERS.Advisor),
			DialogSystem.DialogText.new("It doesn’t matter, she’ll come back anyways.", DialogSystem.CHARACTERS.Ashes),
		], true)
	else:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("I’m sorry Ashes, you left me no other choice.", DialogSystem.CHARACTERS.Mara)
		],true)
	
	DialogSystem.connect("dialog_finished", _final_dialog_ended.bind(win))

func _final_dialog_ended(win):
	if DialogSystem.is_connected("dialog_finished", _final_dialog_ended):
		DialogSystem.disconnect("dialog_finished", _final_dialog_ended)
	super._on_board_game_over(win, board.move_number)

func _enable_play():
	super._enable_play()
	if GameState.state["first_pawn_introduction"]:
		blocking_panel.show()
		run_hint_system()

func run_hint_system() -> void:
	if _hint_index >= hints.size():
		GameState.state["first_karma_table_run"] = false
		GameState.save_game()
		blocking_panel.hide()
		return
	hints[_hint_index].show()
	_hint_index += 1

func _palace_hint_shown() -> void:
	palace_light.visible = hints[3].visible
