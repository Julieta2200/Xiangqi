class_name Level extends Node2D

@export var has_decision: bool
@export var card : CardSlots.SPECIALS
@export var level_name: String
@onready var board: BoardV2 = %Board
@onready var gameplay_ui: GameplayUI = $GameplayUI


func _ready() -> void:
	board.game_over.connect(_on_board_game_over)
	gameplay_ui.power_meter.energy_depleted.connect(game_over_energy_depleted)
	gameplay_ui.decision.set_free.connect(_on_gameplay_ui_set_free)
	gameplay_ui.decision.claim.connect(_on_gameplay_ui_claim)
	gameplay_ui.decision.set_card_name(CardSlots.card_names[card])

func game_over_energy_depleted():
	get_tree().reload_current_scene()

func _on_board_game_over(win, move_number):
	await get_tree().process_frame
	if win:
		update_best_move_number(move_number)
		if GameState.state["levels"][level_name]["state"] != LevelMarker.LevelState.Open:
			load_main_scene()
			return
		if has_decision:
			gameplay_ui.decision_activate()
		else:
			GameState.state["levels"][level_name]["state"] = LevelMarker.LevelState.Captured
			if GameState.state["levels"].has(level_name+"_bonus"):
				GameState.state["levels"][level_name+"_bonus"]["state"] = LevelMarker.LevelState.Open
			if GameState.state["levels"].has(str(int(level_name) + 1)):
				GameState.state["levels"][str(int(level_name)+1)]["state"] = LevelMarker.LevelState.Open
			GameState.save_game()
			load_main_scene()
	else:
		get_tree().reload_current_scene()

func load_main_scene():
	get_tree().change_scene_to_file("res://Projects/Levels/Overworld/overworld.tscn")

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