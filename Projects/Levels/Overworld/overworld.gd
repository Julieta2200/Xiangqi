class_name Overworld extends Node2D

@onready var levels: Dictionary = {
	"1": $"Levels/1",
	"1_bonus": $"Levels/1/bonus_1",
	"2": $"Levels/2",
	"2_bonus": $"Levels/2/bonus_2",
	"3": $"Levels/3",
	"3_bonus": $"Levels/3/bonus_3",
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.state["first_run"]:
		GameState.state["first_run"] = false
		GameState.save_game()
		_on_tutorial_pressed()
	
	for level in GameState.state["levels"]:
		if levels.has(level):
			levels[level].state = GameState.state["levels"][level]["state"]
			levels[level].move_count = GameState.state["levels"][level]["move_count"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_karma_table_pressed() -> void:
	get_tree().change_scene_to_file("res://Projects/KarmaTable/karma_table.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Projects/Levels/Tutorial/tutorial.tscn")
