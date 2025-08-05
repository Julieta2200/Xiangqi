extends Node

var state: Dictionary = {
	"energy": 100,
	"support": ["freeze, defence"],
	"levels": {
		"1": LevelMarker.LevelState.Open,
		"2": LevelMarker.LevelState.Closed,
		"3": LevelMarker.LevelState.Closed
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func save_game() -> void:
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string = JSON.stringify(state)
	save_file.store_line(json_string)
