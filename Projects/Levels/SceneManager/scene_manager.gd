extends Node

enum Scenes {Level_1, Level_2, Level_3, Karma_table, Tutorial, Overworld, MainMenu, Level_1_Boss, Level_1_Bonus, Level_2_Bonus, Level_3_Bonus}

var scenes_path: Dictionary = {
	Scenes.Level_1: "res://Projects/Levels/Level_1/level_1.tscn",
	Scenes.Level_2: "res://Projects/Levels/Level_2/level_2.tscn",
	Scenes.Level_3: "res://Projects/Levels/Level_3/level_3.tscn",
	Scenes.Karma_table: "res://Projects/KarmaTable/karma_table.tscn",
	Scenes.Tutorial: "res://Projects/Levels/Tutorial/tutorial.tscn",
	Scenes.Overworld: "res://Projects/Levels/Overworld/overworld.tscn",
	Scenes.MainMenu : "res://Projects/Ui/MainMenu/main_menu.tscn"
}

var loading_screen_path: String = "res://Projects/LoadingScreen/loading_screen.tscn"

var next_scene_path: String = ""

func change_scene(scene_name: Scenes):
	if !scenes_path.has(scene_name):
		return

	var scene_path = scenes_path[scene_name]
	next_scene_path = scene_path
	get_tree().change_scene_to_file(loading_screen_path)
	DialogSystem.disappear()
