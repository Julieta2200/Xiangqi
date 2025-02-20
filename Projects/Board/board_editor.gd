extends Node2D

var state : Dictionary
const board_rows = 10
const board_cols = 9
var markers : Dictionary

func _ready():
	initialize_markers()

func _on_marker_editor_selected_marker(marker : MarkerEditor):
	if %Garrison.selected_figure != null:
		if !state.has(marker.board_position):
			state[marker.board_position] = {
				"type": %Garrison.selected_figure.type,
				"team": Board.team.Red
			}
		%Garrison.selected_figure = null
		

func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			markers[Vector2(j,i)] = $Markers.get_child(i).get_child(j)
			markers[Vector2(j,i)].board_position = Vector2(j,i)
