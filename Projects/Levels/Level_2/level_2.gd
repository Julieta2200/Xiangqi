extends Level

@onready var blocking_panel: Control = $GameplayUI/BlockingPanel
@onready var hints: Array[HintBubble] = [
	$GameplayUI/Hints/Horses,
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
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(4,5)),
	]
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("You're under attack, Ashes!", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("One more move and you'll be dead.", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("Do you think you can take me out with those knights?", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("I warned you Ashes, Attack!", DialogSystem.CHARACTERS.Mara),
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
