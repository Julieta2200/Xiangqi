extends Node2D

var figures : Dictionary

func _ready() -> void:
	create_editor_figures()

func _on_power_meter_energy_changed(energy: float) -> void:
	%Garrison.energy_changed(energy)

func free_markers_highlight():
	var distance_rows = %PowerMeter.distance / 10 - 1

	for i in %Board.markers:
		var marker = %Board.markers[i].free_marker_highlight
		if i.y >= 7 and i.x >= 3 and i.x <= 5:
			continue
			
		if !%Board.state.has(i) and  i.y <=  distance_rows and in_boundaries(i):
			marker.visible = true
		elif marker.visible:
			marker.visible = false
			

func create_editor_figures():
	for i in %Garrison.figures.keys():
		figures[i] = []
		for j in %Garrison.figures[i]:
			var figure_scene : String = %Board.figure_scenes[i]
			figure_scene = figure_scene.replace("{GROUP}", "Magma")
			var figure = load(figure_scene).instantiate()
			figure.team = Board.team.Red
			figure.board = %Board
			figure.global_position = Vector2(0, -1000)
			$Editor_figures.add_child(figure)
			figures[i].append(figure)

func place_figures(marker):
	if %Garrison.selected_figure != null:
		if %Board.state.has(marker.board_position):
			return
		
		var figure = figures[%Garrison.selected_figure.type].pop_front()
		figure.global_position = %Board.markers[marker.board_position].global_position
		figure.board_position = marker.board_position
		%Board.state[marker.board_position] = figure
		%Board.calculate_moves()

		free_markers_highlight()
		%Garrison.removing_selected_figure()

func in_boundaries(pos : Vector2) -> bool:
	if %Garrison.selected_figure.type == Figure.Types.Elephant:
		return pos.y <= 4
	return true
	
