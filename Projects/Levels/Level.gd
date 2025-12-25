class_name Level extends Node2D

@export var has_decision: bool
@export var card : CardSlots.SPECIALS
@export var level_name: String
@export var garrison_limitations: Array[FigureComponent.Types] = []
@onready var board: BoardV2 = %Board
@onready var gameplay_ui: GameplayUI = $GameplayUI
@onready var background_animation: AnimationPlayer = $Background/AnimationPlayer
@onready var pause_menu: Control = $Menu/PauseMenu
@onready var music: Node2D = $Music



func _ready() -> void:
	board.level = self
	board.game_over.connect(_on_game_over)
	gameplay_ui.power_meter.energy_depleted.connect(game_over_energy_depleted)
	gameplay_ui.decision.set_free.connect(_on_gameplay_ui_set_free)
	gameplay_ui.decision.claim.connect(_on_gameplay_ui_claim)
	gameplay_ui.decision.set_card_name(CardSlots.card_names[card])
	gameplay_ui.garrison.garrison_limitations = garrison_limitations
	gameplay_ui.garrison.update_cards(gameplay_ui.power_meter.energy)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		if pause_menu.visible:
			pause_menu.hide()
			music.audio_player.stream_paused = false
		else:
			pause_menu.show()
			music.audio_player.stream_paused = true

func game_over_energy_depleted():
	show_game_over_ui()

func _on_game_over(win: BoardV2.GameOverResults, move_number: int):
	await get_tree().process_frame
	if win == BoardV2.GameOverResults.Win:
		gameplay_ui.objectives.complete_objectives(true)
		update_best_move_number(move_number)
		if GameState.state["levels"][level_name]["state"] != LevelMarker.LevelState.Open:
			load_main_scene()
			return
		if has_decision:
			load_decision_dialog()
		else:
			GameState.state["levels"][level_name]["state"] = LevelMarker.LevelState.Captured
			if GameState.state["levels"].has(level_name+"_bonus"):
				GameState.state["levels"][level_name+"_bonus"]["state"] = LevelMarker.LevelState.Open
			if GameState.state["levels"].has(str(int(level_name) + 1)):
				GameState.state["levels"][str(int(level_name)+1)]["state"] = LevelMarker.LevelState.Open
			GameState.save_game()
			load_main_scene()
	else:
		gameplay_ui.objectives.complete_objectives(false)
		show_game_over_ui()

func load_decision_dialog() -> void:
	load_main_scene()

func show_game_over_ui():
	music.audio_player.stream_paused = true
	gameplay_ui.show_game_over_ui()
	if gameplay_ui.power_meter.energy == 0:
		var message = DialogSystem.game_over_dialog_texts[randi() % DialogSystem.game_over_dialog_texts.size()]
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new(message, DialogSystem.CHARACTERS.Jakat)
		], true)


func load_main_scene():
	SceneManager.change_scene(SceneManager.Scenes.Overworld)

func _on_gameplay_ui_set_free() -> void:
	GameState.state["ll_cards"].append(card)
	GameState.state["levels"][level_name]["state"] = LevelMarker.LevelState.Free
	GameState.save_game()
	load_main_scene()

func _on_gameplay_ui_claim():
	GameState.add_orb()
	GameState.state["levels"][level_name]["state"] = LevelMarker.LevelState.Captured
	GameState.save_game()
	load_main_scene()

func update_best_move_number(current_move_number: int)-> void:
	if !GameState.state["levels"].has(level_name):
		return
	if current_move_number < GameState.state["levels"][level_name]["move_count"] or GameState.state["levels"][level_name]["move_count"] == 0:
		GameState.state["levels"][level_name]["move_count"] = current_move_number
		GameState.save_game()

func _enable_play() -> void:
	gameplay_ui.show()
	board.activate_reds(true)
	if DialogSystem.is_connected("dialog_finished", _enable_play):
		DialogSystem.disconnect("dialog_finished", _enable_play)

func _disable_play() -> void:
	gameplay_ui.hide()
	board.activate_reds(false)

func check_game_over() -> bool:
	if board.tutorial:
		return false
	var generals = board.get_generals()
	if generals.size() < 2:
		var win: bool = board.is_victory(generals)
		var result: BoardV2.GameOverResults = BoardV2.GameOverResults.Win if win else BoardV2.GameOverResults.Lose
		_on_game_over(result, board.move_number)
		return true
	return false
