extends Node2D

var state : Dictionary
const board_rows = 10
const board_cols = 9
var markers : Dictionary
@export var garrison: Dictionary = {Figure.Types.Soldier: 0,Figure.Types.Elephant:0,Figure.Types.Chariot:0,Figure.Types.Horse: 0,Figure.Types.Cannon:0}
signal start(state: Dictionary)
var figures: Dictionary

var figure_scenes: Dictionary = {
	Figure.Types.General: preload("res://Projects/Figure/Magma/General/general.tscn"),
	Figure.Types.Advisor: preload("res://Projects/Figure/Magma/Advisor/advisor.tscn"),
	Figure.Types.Soldier: preload("res://Projects/Figure/Magma/Soldier/soldier.tscn"),
	Figure.Types.Elephant: preload("res://Projects/Figure/Magma/Elephant/elephant.tscn"),
	Figure.Types.Chariot: preload("res://Projects/Figure/Magma/Chariot/chariot.tscn"),
	Figure.Types.Horse: preload("res://Projects/Figure/Magma/Horse/horse.tscn"),
	Figure.Types.Cannon: preload("res://Projects/Figure/Magma/Cannon/cannon.tscn"),
}

func _ready():
	initialize_markers()
	create_figures()
	%Garrison.fill_the_cards(garrison)

func create_figures():
	for i in garrison.keys():
		figures[i] = []
		for j in garrison[i]:
			var figure = figure_scenes[i].instantiate()
			figure.team = Board.team.Red
			$Figures.add_child(figure)
			figures[i].append(figure)

func _on_marker_editor_selected_marker(marker : MarkerEditor):
	if %Garrison.selected_figure != null and in_boundaries(marker.board_position):
		if state.has(marker.board_position):
			return
		
		var figure = figures[%Garrison.selected_figure.type].pop_front()
		state[marker.board_position] = {
			"type": figure.type,
			"team": Board.team.Red
		}

		figure.global_position = markers[marker.board_position].global_position
		%Garrison.removing_selected_figure()

func in_boundaries(pos : Vector2) -> bool:
	if %Garrison.selected_figure.type == Figure.Types.Elephant:
		return pos.y <= 4
	return true
	
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


func _create_static_figures(static_figures: Dictionary) -> void:
	for i in static_figures:
		var figure = figure_scenes[static_figures[i].type].instantiate()
		figure.team = static_figures[i].team
		figure.global_position = markers[i].global_position
		$Static_figures.add_child(figure)
	state.merge(static_figures)
