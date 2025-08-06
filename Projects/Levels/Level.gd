class_name Level extends Node2D

@export var has_decision: bool = true
@export var support : Array
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
	if win:
		if has_decision:
			gameplay_ui.decision_activate()
		else:
			load_main_scene()
	else:
		get_tree().reload_current_scene()

func load_main_scene():
	get_tree().change_scene_to_file("res://Projects/Levels/Overworld/overworld.tscn")

func _on_gameplay_ui_set_free() -> void:
	support = GameState.state["support"]
	gameplay_ui.decision_deactivate()
	load_main_scene()

func _on_gameplay_ui_claim():
	gameplay_ui.power_meter.energy += 15
	gameplay_ui.decision_deactivate()
	load_main_scene()
