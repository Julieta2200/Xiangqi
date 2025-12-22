extends Node

enum Scenes {Level_1, Level_2, Level_3, Karma_table, Tutorial, Overworld, MainMenu}

var scenes_path: Dictionary = {
	Scenes.Level_1: "res://Projects/Levels/Level_1/level_1.tscn",
	Scenes.Level_2: "res://Projects/Levels/Level_2/level_2.tscn",
	Scenes.Level_3: "res://Projects/Levels/Level_3/level_3.tscn",
	Scenes.Karma_table: "res://Projects/KarmaTable/karma_table.tscn",
	Scenes.Tutorial: "res://Projects/Levels/Tutorial/tutorial.tscn",
	Scenes.Overworld: "res://Projects/Levels/Overworld/overworld.tscn",
	Scenes.MainMenu : "res://Projects/Ui/MainMenu/main_menu.tscn"
}

func change_scene(scene_name: Scenes):
	if !scenes_path.has(scene_name):
		return

	var scene_path = scenes_path[scene_name]
	get_tree().change_scene_to_file(scene_path)
	DialogSystem.disappear()
