extends Level

@onready var blocking_panel: Control = $GameplayUI/BlockingPanel
@onready var hints: Array[HintBubble] = [
	$GameplayUI/Hints/HintBubble,
]
var _hint_index: int = 0

func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(4,1)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(3,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(5,9)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,7)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(3,7)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(5,7)),
	]
	board.initialize_position(state)
	_disable_play()
	_enable_play()

func check_game_over() -> bool:
	if super.check_game_over():
		return true
	if board.move_number > 10:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	return false

func _enable_play():
	super._enable_play()
	if GameState.state["first_bonus_introduction"]:
		blocking_panel.show()
		run_hint_system()

func run_hint_system() -> void:
	if _hint_index >= hints.size():
		GameState.state["first_bonus_introduction"] = false
		GameState.save_game()
		blocking_panel.hide()
		return
	hints[_hint_index].show()
	_hint_index += 1