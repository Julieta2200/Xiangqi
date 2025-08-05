class_name Level extends Node2D


@onready var board: BoardV2 = %Board

func _ready() -> void:
	board.game_over.connect(_on_board_game_over)
	$GameplayUI.power_meter.energy_depleted.connect(game_over_energy_depleted)


func game_over_energy_depleted():
	load_main_scene()

func _on_board_game_over(winner_team):
	load_main_scene()

func load_main_scene():
	get_tree().change_scene_to_file("res://Projects/Levels/Overworld/overworld.tscn")
