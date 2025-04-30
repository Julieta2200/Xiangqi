extends Node2D

func _on_power_meter_energy_changed(energy: float) -> void:
	%Garrison.energy_changed(energy)


func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	%Board.highlight_placeholder_markers(selected_card, %PowerMeter.distance/10 - 1)


func _on_board_set_figure(marker: BoardMarker) -> void:
	%Board.set_figure(%Garrison.selected_figure.type,
	 marker.board_position, "Magma", Board.team.Red, false,  true)
	%PowerMeter.energy -= %Garrison.selected_figure.energy
	%Garrison.remove_figure()
	%PowerMeter.fill_distance()

func _on_board_figure_move_done() -> void:
	%PowerMeter.fill_energy()


func _on_board_enemy_figure_selected(figure: Figure) -> void:
	if %Garrison.eliminate_button_active:
		%Board. enemy_figures_by_type_delete(figure)
		%Garrison.eliminate_button_active = false
		%PowerMeter.energy -= 100
