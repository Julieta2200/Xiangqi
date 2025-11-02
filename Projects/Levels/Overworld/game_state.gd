extends Node

const VERSION: int = 1

var state: Dictionary = {
	"version": 1,
	"energy": 100,
	"ll_cards": [],
	"hl_cards": [],
	"lls": [],
	"hl": -1,
	"orbs": 0,
	"levels": {
		"1": {
			"state": LevelMarker.LevelState.Open,
			"move_count" : 0
		},
		"1_bonus": {
			"state": LevelMarker.LevelState.Closed,
			"move_count" : 0
		},
		"2": {
			"state": LevelMarker.LevelState.Closed,
			"move_count" : 0
		},
		"2_bonus": {
			"state": LevelMarker.LevelState.Closed,
			"move_count" : 0
		},
		"3": {
			"state": LevelMarker.LevelState.Closed,
			"move_count" : 0
		},
		"3_bonus": {
			"state": LevelMarker.LevelState.Closed,
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
}

var current_level_info: Dictionary = {
	"scene": null,
	"name": "",
	"objectives": [],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_game()


func add_orb() -> void:
	state["orbs"] += 1
	for s in CardSlots.hl_points:
		if state["orbs"] == CardSlots.hl_points[s]:
			state["hl_cards"].append(s)

func save_game() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(state)
	save_file.store_line(json_string)

func load_game() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		return
		
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
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
	state = s
