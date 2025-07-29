class_name Level extends Node2D


@onready var board: BoardV2 = %Board

func _ready() -> void:
	$GameplayUI.power_meter.energy_depleted.connect(game_over_energy_depleted)


func game_over_energy_depleted():
	get_tree().change_scene_to_file("res://Projects/Levels/PrototypeMenu/prototype_menu.tscn")
