extends Node

const VERSION: int = 1
const SAVE_FILE_NAME: String = "savegame.save"

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

var current_level_info: Dictionary = {
	"scene": null,
	"name": "",
	"objectives": [],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()

func new_game() -> void:
	state = new_state.duplicate(true)
	save_game()

func add_orb() -> void:
	state["orbs"] += 1
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
		if state["levels"].has(level_name+"_bonus"):
			state["levels"][level_name+"_bonus"]["state"] = LevelMarker.LevelState.Open
		if state["levels"].has(str(int(level_name) + 1)):
			state["levels"][str(int(level_name)+1)]["state"] = LevelMarker.LevelState.Open
	save_game()