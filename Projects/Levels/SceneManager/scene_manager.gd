extends Node

var scenes: Dictionary = {
	"level_1": "res://Projects/Levels/Level_1/level_1.tscn",
	"level_2": "res://Projects/Levels/Level_2/level_2.tscn",
	"level_3": "res://Projects/Levels/Level_3/level_3.tscn",
	"bonus_level_1": "res://Projects/Levels/Bonus_levels/bonus_level.tscn",
	"bonus_level_2": "res://Projects/Levels/Bonus_levels/Bonus_level_2/bonus_level_2.tscn",
	"bonus_level_3": "res://Projects/Levels/Bonus_levels/Bonus_level_3/bonus_level_3.tscn",
	"karma_table": "res://Projects/KarmaTable/karma_table.tscn",
	"tutorial": "res://Projects/Levels/Tutorial/tutorial.tscn",
	"overworld": "res://Projects/Levels/Overworld/overworld.tscn"
}

func change_scene(scene_name: String):
	if !scenes.has(scene_name):
		return

	var scene_path = scenes[scene_name]
	get_tree().change_scene_to_file(scene_path)
	DialogSystem.disappear()
