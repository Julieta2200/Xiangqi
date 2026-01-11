class_name BoardMultiplayer extends Board

func _on_figure_selected(figure):
	if figure.team == turn and can_move:
		if selected_figure != null:
			selected_figure.delete_highlight()
			markers[selected_figure.board_position].unhighlight()
		selected_figure = figure
		selected_figure.highlight_moves()

func _on_figure_move_done():
	if turn == team.Red:
		turn = team.Black
	else:
		turn = team.Red
		move_number += 1
	
	can_move = true
	emit_signal("figure_move_done")

func _on_turn_changed():
	pass
