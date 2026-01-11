class_name BoardStory extends Board

# save_states is used to keep the history of the game
# in order to get back to that position if needed.
var save_states: Dictionary = {}

# move_computer emitted when it's computers turn to move
signal move_computer

# Override hook method to add story-specific turn logic
func _on_turn_changed():
	if turn == team.Black:
		move_number += 1
		emit_signal("move_computer")

# Generates and saves the current state of all figures for the current move
func generate_save_state() -> void:
	var generated_state: Dictionary
	for pos in state:
		generated_state[pos] = {
			"type": state[pos].type,
			"team": state[pos].team,
			"group": groups[state[pos].team]
		}
		
		if !state[pos].active:
			generated_state[pos].inactive = true
	save_states[move_number] = generated_state

# Loads the saved state of a specific move and sets the turn to Red team
func load_move(move: int) -> void:
	move_number = move
	turn = team.Red
	create_state(save_states[move])

# Executes a move for the computer(black figures), 
# updating the figure's position and generating the new state
func computer_move(pos: Vector2, new_pos: Vector2) -> bool:
	unhighlight_markers()
	if !state.has(pos) or state[pos].team != turn:
		return false
	if state.has(new_pos):
		state[new_pos].delete()
	state[pos].move(markers[new_pos])
	# Save state immediately after computer move (board_position is updated synchronously)
	generate_save_state()
	return true

# Makes visible markers based on the distance, and figures movement rules
func highlight_placeholder_markers(selected_card: FigureCard, distance: int) -> void:
	can_move = false
	
	# We store all the markers that have become visible,
	# the key is the position(Vector2) and the value is the marker
	var position_markers : Dictionary
	for i in markers:
		var highlight = markers[i].position_marker
		highlight.visible = !palace_positions.has(i) and !state.has(i) and \
		 i.y <=  distance and in_boundaries(i, selected_card) 
		if highlight.visible:
			position_markers[i] = markers[i]
	
	for i in position_markers:
		position_markers[i].horizontal_line.visible = position_markers.has(Vector2(i.x+1,i.y))
		position_markers[i].vertical_line.visible = position_markers.has(Vector2(i.x,i.y+1))

func in_boundaries(pos : Vector2, card: FigureCard) -> bool:
	if card.type == Figure.Types.Elephant:
		return pos.y <= 4
	return true

# _set_figure is emitted when new figure is added to the board via garrison
signal _set_figure(marker: BoardMarker)

func _on_marker_figure_set(marker: Variant) -> void:
	emit_signal("_set_figure", marker)

# Override to maintain story-specific turn logic: Red player, Black computer
func _on_figure_move_done():
	if turn == team.Black:
		# Computer just moved (state already saved in computer_move()), switch to player
		turn = team.Red
		can_move = true
	else:
		# Player just moved, switch to computer
		turn = team.Black
		emit_signal("figure_move_done")

# Override to only allow Red team (player) to select figures, Black is controlled by computer
func _on_figure_selected(figure):
	if figure.team == team.Red and can_move:
		if selected_figure != null:
			selected_figure.delete_highlight()
			markers[selected_figure.board_position].unhighlight()
		selected_figure = figure
		selected_figure.highlight_moves()
