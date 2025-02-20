extends Node2D

var state : Dictionary
const board_rows = 10
const board_cols = 9
var markers : Dictionary
@export var garrison: Dictionary = {Figure.Types.Soldier: 0,Figure.Types.Elephant:0,Figure.Types.Chariot:0,Figure.Types.Horse: 0,Figure.Types.Cannon:0}

signal start(state: Dictionary)

var figures: Dictionary

var figure_scenes: Dictionary = {
	Figure.Types.Soldier: preload("res://Projects/Figure/Soldier/soldier.tscn"),
	Figure.Types.Elephant: preload("res://Projects/Figure/Elephant/elephant.tscn"),
	Figure.Types.Chariot: preload("res://Projects/Figure/Chariot/chariot.tscn"),
	Figure.Types.Horse: preload("res://Projects/Figure/Horse/horse.tscn"),
	Figure.Types.Cannon: preload("res://Projects/Figure/Cannon/cannon.tscn"),
}

func _ready():
	for i in garrison.keys():
		figures[i] = []
		for j in garrison[i]:
			var figure = figure_scenes[i].instantiate()
			figure.team = Board.team.Red
			$Figures.add_child(figure)
			figures[i].append(figure)
	%Garrison.fill_the_cards(garrison)
	initialize_markers()

func _on_marker_editor_selected_marker(marker : MarkerEditor):
	if %Garrison.selected_figure != null:
		if state.has(marker.board_position):
			return

		state[marker.board_position] = {
			"type": %Garrison.selected_figure.type,
			"team": Board.team.Red
		}
		
		var figure = figures[%Garrison.selected_figure.type].pop_front()
		if figure != null:
			figure.global_position = markers[marker.board_position].global_position
		
		%Garrison.removing_selected_figure()
	

func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			markers[Vector2(j,i)] = $Markers.get_child(i).get_child(j)
			markers[Vector2(j,i)].board_position = Vector2(j,i)


func _on_garrison_save() -> void:
	emit_signal("start", state)


func _on_visibility_changed() -> void:
	if !visible:
		$CanvasLayer.hide()
