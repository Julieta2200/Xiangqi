extends Node

var state: Dictionary = {
	"energy": 100,
	"support": ["freeze, wall"],
	"levels": {
		"1": LevelMarker.LevelState.Open,
		"2": LevelMarker.LevelState.Closed,
		"3": LevelMarker.LevelState.Closed
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	state = json.data
