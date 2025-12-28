extends Level

@onready var blocking_panel: Control = $GameplayUI/BlockingPanel
@onready var hints: Array[HintBubble] = [
	$GameplayUI/Hints/HintBubble,
	$GameplayUI/Hints/FlyingGeneral,
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
	if board.move_number > 7:
		ran_out_of_moves_dialog()
		return true

	if board.get_figures(BoardV2.Teams.Red).filter(func(f): return f.type == FigureComponent.Types.SOLDIER).size() == 0:
		ran_out_of_pawns_dialog()
		return true

	return false

func _enable_play():
	super._enable_play()
	if GameState.state["first_bonus_introduction"]:
		blocking_panel.show()
		run_hint_system()
	else:
		attack_dialog()

func attack_dialog() -> void:
	# this is the dialog when level is played for the first time
	if GameState.get_level_state(level_name) == LevelMarker.LevelState.Open \
	or GameState.get_level_state(level_name) == LevelMarker.LevelState.Closed:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("BONUS_LEVEL_ATTACK_DIALOG_1", DialogSystem.CHARACTERS.Ashes),
			DialogSystem.DialogText.new("BONUS_LEVEL_ATTACK_DIALOG_2", DialogSystem.CHARACTERS.Aros),
			DialogSystem.DialogText.new("BONUS_LEVEL_ATTACK_DIALOG_3", DialogSystem.CHARACTERS.Ashes),
			DialogSystem.DialogText.new("BONUS_LEVEL_ATTACK_DIALOG_4", DialogSystem.CHARACTERS.Aros),
			DialogSystem.DialogText.new("BONUS_LEVEL_ATTACK_DIALOG_5", DialogSystem.CHARACTERS.Ashes)], true)
		return

	if GameState.get_level_state(level_name) == LevelMarker.LevelState.Free:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("BONUS_LEVEL_DAVADIT_1", DialogSystem.CHARACTERS.Ashes)], true)
	else:
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new("BONUS_LEVEL_DAVADIT_2", DialogSystem.CHARACTERS.Aros)], true)


func run_hint_system() -> void:
	if _hint_index >= hints.size():
		GameState.state["first_bonus_introduction"] = false
		GameState.save_game()
		blocking_panel.hide()
		attack_dialog()
		return
	AudioManager.play_sound("dialog_box")
	hints[_hint_index].show()
	_hint_index += 1

func ran_out_of_pawns_dialog() -> void:
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("BONUS_LEVEL_RAN_OUT_OF_XINVORS", DialogSystem.CHARACTERS.Advisor)], true)
	DialogSystem.connect("dialog_finished", _ran_out_of_pawns_dialog_finished)

func _ran_out_of_pawns_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _ran_out_of_pawns_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _ran_out_of_pawns_dialog_finished)
	_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)


func ran_out_of_moves_dialog() -> void:
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("BONUS_LEVEL_RAN_OUT_OF_TIME", DialogSystem.CHARACTERS.Jakat)], true)
	DialogSystem.connect("dialog_finished", _ran_out_of_moves_dialog_finished)

func _ran_out_of_moves_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _ran_out_of_moves_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _ran_out_of_moves_dialog_finished)
	_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)

func _flying_general_hint_shown() -> void:
	var generals: Array[FigureComponent] = board.get_figures_by_type(FigureComponent.Types.GENERAL)
	if hints[1].visible:
		for general in generals:
			general.shader_component.hint_highlight()
	else:
		for general in generals:
			general.shader_component.hint_unhighlight()

var _decision_option: Dictionary = {}

func load_decision_dialog() -> void:
	if GameState.get_level_state(level_name) == LevelMarker.LevelState.Captured:
		load_main_scene() # this is the case when level is already captured and we beat it again
		return
	# This is dialog for the first time when level is not captured yet (it can also be freed before)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("BONUS_LEVEL_DECISION_DIALOG_1", DialogSystem.CHARACTERS.Jakat),
		DialogSystem.DialogText.new("", DialogSystem.CHARACTERS.Ashes, [
			{"text": "BONUS_LEVEL_DECISION_DIALOG_2"}, {"text": "BONUS_LEVEL_DECISION_DIALOG_3"}])
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
	
	if _decision_option["text"] == "BONUS_LEVEL_DECISION_DIALOG_2":
		# Set free option
		GameState.set_level_state(level_name, LevelMarker.LevelState.Free)
		GameState.set_ll_card(card)
		follow_up_dialogs = [
			DialogSystem.DialogText.new("BONUS_LEVEL_DECISION_SET_FREE_AROS", DialogSystem.CHARACTERS.Aros),
			DialogSystem.DialogText.new("BONUS_LEVEL_DECISION_SET_FREE_JAKAT", DialogSystem.CHARACTERS.Jakat)
		]
	else:
		# Claim option
		GameState.set_level_state(level_name, LevelMarker.LevelState.Captured)
		GameState.remove_ll_card(card)
		GameState.add_orb()
		follow_up_dialogs = [
			DialogSystem.DialogText.new("BONUS_LEVEL_DECISION_CLAIM_AROS", DialogSystem.CHARACTERS.Aros),
			DialogSystem.DialogText.new("BONUS_LEVEL_DECISION_CLAIM_JAKAT", DialogSystem.CHARACTERS.Jakat)
		]
	
	_decision_option = {}
	DialogSystem.start_dialog(follow_up_dialogs, true)
	DialogSystem.connect("dialog_finished", _follow_up_dialog_finished)

func _follow_up_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _follow_up_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _follow_up_dialog_finished)
	load_main_scene()