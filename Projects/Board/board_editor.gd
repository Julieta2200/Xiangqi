extends Node2D

var state : Dictionary
const board_rows = 10
const board_cols = 9
var markers : Dictionary
var figures: Dictionary = {Figure.Types.Soldier: 3,Figure.Types.Elephant:1,Figure.Types.Chariot:2,Figure.Types.Horse: 0,Figure.Types.Cannon:2}

var figure_scenes: Dictionary = {
	Figure.Types.Soldier: preload("res://Projects/Figure/Soldier/soldier.tscn"),
	Figure.Types.Elephant: preload("res://Projects/Figure/Elephant/elephant.tscn"),
	Figure.Types.Chariot: preload("res://Projects/Figure/Chariot/chariot.tscn"),
	Figure.Types.Horse: preload("res://Projects/Figure/Horse/horse.tscn"),
	Figure.Types.Cannon: preload("res://Projects/Figure/Cannon/cannon.tscn"),
}

func _ready():
	for i in figures.keys():
		for j in figures[i]:
			var figure = figure_scenes[i].instantiate()
			figure.team = Board.team.Red
			$Figures.add_child(figure)
	%Garrison.fill_the_cards(figures)
	initialize_markers()

func _on_marker_editor_selected_marker(marker : MarkerEditor):
	if %Garrison.selected_figure != null:
		if state.has(marker.board_position):
			return

		state[marker.board_position] = {
			"type": %Garrison.selected_figure.type,
			"team": Board.team.Red
		}
		for i in $Figures.get_children():
			if i.type == %Garrison.selected_figure.type and i.global_position < Vector2.ZERO:
				i.global_position = markers[marker.board_position].global_position
				break
		%Garrison.removing_selected_figure()
	

func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			markers[Vector2(j,i)] = $Markers.get_child(i).get_child(j)
			markers[Vector2(j,i)].board_position = Vector2(j,i)
