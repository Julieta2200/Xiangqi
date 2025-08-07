class_name Level extends Node2D

@export var has_decision: bool
@export var support : String
@export var level_name: String
@onready var board: BoardV2 = %Board
@onready var gameplay_ui: GameplayUI = $GameplayUI


func _ready() -> void:
	board.game_over.connect(_on_board_game_over)
	gameplay_ui.power_meter.energy_depleted.connect(game_over_energy_depleted)
	gameplay_ui.decision.set_free.connect(_on_gameplay_ui_set_free)
	gameplay_ui.decision.claim.connect(_on_gameplay_ui_claim)


func game_over_energy_depleted():
	load_main_scene()

func _on_board_game_over(win):
	await get_tree().process_frame
	if win:
		if has_decision:
			gameplay_ui.decision_activate()
		else:
			GameState.state["levels"][level_name] = LevelMarker.LevelState.Captured
			GameState.state["levels"][level_name+"_bonus"] = LevelMarker.LevelState.Open
			GameState.state["levels"][str(int(level_name)+1)] = LevelMarker.LevelState.Open
			GameState.save_game()
			load_main_scene()
	else:
		get_tree().reload_current_scene()

func load_main_scene():
	get_tree().change_scene_to_file("res://Projects/Levels/Overworld/overworld.tscn")

func _on_gameplay_ui_set_free() -> void:
	GameState.state["support"].append(support)
	GameState.state["levels"][level_name] = LevelMarker.LevelState.Free
	GameState.save_game()
	load_main_scene()

func _on_gameplay_ui_claim():
	GameState.state["energy"] += 15
	GameState.state["levels"][level_name] = LevelMarker.LevelState.Captured
	GameState.save_game()
	load_main_scene()
