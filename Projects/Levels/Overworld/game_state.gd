extends Node

const VERSION: int = 1
const SAVE_FILE_NAME: String = "savegame.save"
const CONFIG_FILE_NAME: String = "config.save"

var state: Dictionary = {}

const new_state: Dictionary = {
	"version": 1,
	"energy": 100,
	"ll_cards": [],
	"hl_cards": [],
	"lls": [],
	"hl": -1,
	"orbs": 0,
	"levels": {
		"1": {
			"state": 1,
			"move_count" : 0
		},
		"1_bonus": {
			"state": 0,
			"move_count" : 0
		},
		"2": {
			"state": 0,
			"move_count" : 0
		},
		"2_bonus": {
			"state": 0,
			"move_count" : 0
		},
		"3": {
			"state": 0,
			"move_count" : 0
		},
		"3_bonus": {
			"state": 0,
			"move_count" : 0
		},
		"1_boss": {
			"state": 0,
			"move_count" : 0
		},
	},
	"passed_tutorials": [],
	"first_run": true,
	"first_karma_table_run": true,
	"first_pawn_introduction": true,
	"first_bonus_introduction": true,
	"first_horse_introduction": true,
	"first_ll_introduction": true,
	"first_chariot_introduction": true,
	"first_overworld_wasd_hint": true,
}

var config: Dictionary = {}

const new_config: Dictionary = {
	"music_volume": -0.030508,
	"sfx_volume": -7.63072,
}

var current_level_info: Dictionary = {
	"scene": null,
	"name": "",
	"objectives": [],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	load_config()

func new_game() -> void:
	state = new_state.duplicate(true)
	save_game()

func add_orb() -> void:
	state["orbs"] += 1
	save_game()
	for s in CardSlots.hl_points:
		if state["orbs"] == CardSlots.hl_points[s]:
			state["hl_cards"].append(s)

func save_game() -> void:
	var save_file = FileAccess.open("user://" + SAVE_FILE_NAME, FileAccess.WRITE)
	var json_string = JSON.stringify(state)
	save_file.store_line(json_string)

func load_game() -> void:
	if not FileAccess.file_exists("user://" + SAVE_FILE_NAME):
		return
		
	var save_file = FileAccess.open("user://" + SAVE_FILE_NAME, FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var s = json.data
	if !s.has("version"):
		return
	if !s.has("first_run"):
		s["first_run"] = true
	if !s.has("first_karma_table_run"):
		s["first_karma_table_run"] = true
	if !s.has("first_pawn_introduction"):
		s["first_pawn_introduction"] = true
	if !s.has("first_bonus_introduction"):
		s["first_bonus_introduction"] = true
	if !s.has("first_horse_introduction"):
		s["first_horse_introduction"] = true
	if !s.has("first_ll_introduction"):
		s["first_ll_introduction"] = true
	if !s.has("first_chariot_introduction"):
		s["first_chariot_introduction"] = true
	if !s.has("first_overworld_wasd_hint"):
		s["first_overworld_wasd_hint"] = true
	# Ensure levels dictionary exists
	if !s.has("levels"):
		s["levels"] = {}
	
	# Add any new levels from new_state that don't exist in loaded state
	for level_name in new_state["levels"]:
		if !s["levels"].has(level_name):
			s["levels"][level_name] = new_state["levels"][level_name].duplicate(true)
	
	state = s

func save_exists() -> bool:
	return FileAccess.file_exists("user://" + SAVE_FILE_NAME)

func set_level_state(level_name: String, level_state: LevelMarker.LevelState) -> void:
	if not state["levels"].has(level_name):
		return
	state["levels"][level_name]["state"] = level_state
	if level_state == LevelMarker.LevelState.Captured:
		if state["levels"].has(level_name+"_bonus") and state["levels"][level_name+"_bonus"]["state"] == LevelMarker.LevelState.Closed:
			state["levels"][level_name+"_bonus"]["state"] = LevelMarker.LevelState.Open
		if state["levels"].has(str(int(level_name) + 1)) and state["levels"][str(int(level_name)+1)]["state"] == LevelMarker.LevelState.Closed:
			state["levels"][str(int(level_name)+1)]["state"] = LevelMarker.LevelState.Open
		if level_name == "3" and state["levels"]["1_boss"]["state"] == LevelMarker.LevelState.Closed:
			state["levels"]["1_boss"]["state"] = LevelMarker.LevelState.Open
	save_game()

func set_ll_card(ll_card: CardSlots.SPECIALS) -> void:
	state["ll_cards"].append(ll_card)
	save_game()

func remove_ll_card(ll_card: CardSlots.SPECIALS) -> void:
	state["ll_cards"] = state["ll_cards"].filter(func(c): return c != ll_card)
	state["lls"] = state["lls"].filter(func(c): return c != ll_card)
	save_game()


func get_level_state(level_name: String) -> LevelMarker.LevelState:
	if not state["levels"].has(level_name):
		return LevelMarker.LevelState.Closed
	return state["levels"][level_name]["state"]

func load_config() -> void:
	if not FileAccess.file_exists("user://" + CONFIG_FILE_NAME):
		config = new_config.duplicate(true)
		return
	var config_file = FileAccess.open("user://" + CONFIG_FILE_NAME, FileAccess.READ)
	var json_string = config_file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var c = json.data
	var music_bus_index = AudioServer.get_bus_index("Music")
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	if c.has("music_volume"):
		if c["music_volume"] == -30.0:
			AudioServer.set_bus_mute(music_bus_index, true)
		else:
			AudioServer.set_bus_mute(music_bus_index, false)
		AudioServer.set_bus_volume_db(music_bus_index, c["music_volume"])
	if c.has("sfx_volume"):
		if c["sfx_volume"] == -30.0:
			AudioServer.set_bus_mute(sfx_bus_index, true)
		else:
			AudioServer.set_bus_mute(sfx_bus_index, false)
		AudioServer.set_bus_volume_db(sfx_bus_index, c["sfx_volume"])
	config = c

func save_config() -> void:
	var config_file = FileAccess.open("user://" + CONFIG_FILE_NAME, FileAccess.WRITE)
	var json_string = JSON.stringify(config)
	config_file.store_line(json_string)

func get_orbs() -> int:
	return state["orbs"]