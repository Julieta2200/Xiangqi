extends Node2D

var initial_state = {
		Vector2(4, 0): {
			"type": Figure.Types.General,
			"team": Board.team.Red,
			"inactive" : true,
			"group": "Magma"
		},
		Vector2(3, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : true,
			"group": "Magma"
		},
		Vector2(5, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : true,
			"group": "Magma"
		},
	}

var first_time: bool = true

func _ready():
	camera_zoom()
	
	%Board.create_state(initial_state)

func camera_zoom():
	%Dialog.appear("You can scroll to zoom in and out to have a better view of surroundings (If mouse scroll doesn't work please use Q,E keys, sorry we're still developing :) )",
	camera_movement)

func camera_movement():
	%Dialog.appear("Use W, A, S, D to look around.",look_out)

func look_out():
	%Dialog.appear("Look! An enemy soldier is approaching.")
	$Camera/AnimationPlayer.play("enemy_spawn")

func soldier_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(4,7), "Cloud", Board.team.Black)
	%Dialog.appear("Don’t go any further!!!",spawn_garrison)
	await get_tree().create_timer(3).timeout
	$Camera/AnimationPlayer.play("RESET")

func spawn_garrison():
	%Dialog.appear("We have a few soldiers with us, but you need to summon them.")
	await get_tree().create_timer(3).timeout
	%PowerMeter.show_energy_bar()
	%Dialog.appear("To summon a soldier you need to have enough energy.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("To get more energy you need to capture enemy soldiers.")
	
func explain_pawn_card():
	%Garrison.show()
	%Dialog.appear("Click on the pawn card to summon it.")
	%Garrison.get_soldier_card().highlight()
	await get_tree().create_timer(3).timeout
	%Garrison.get_soldier_card().unhighlight()

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	if first_time:
		summon_soldier()

func summon_soldier():
	%Dialog.appear("The distance meter shows how far in the arena you can summon your soldiers.")
	%PowerMeter.show_distance_bar()
	await get_tree().create_timer(3).timeout
	%Dialog.appear("The more soldiers you have the longer the distance. You can’t summon a soldier inside the palace.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Click on one of the markers to summon your soldier there.")


func _on_board_set_figure(marker: BoardMarker) -> void:
	if first_time:
		move_and_capture_enemy()

func move_and_capture_enemy() -> void:
	%Dialog.appear("Now it’s our turn to move.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Click on a pawn to see all possible moves.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Pawns can move only forward, by one step, once they cross the river, they can also move one step horizontally.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Capture the enemy pawn.")
	first_time = false


func check_status():
	var soldier = %Board.get_figures(Board.team.Red, Figure.Types.Soldier)
	var enemy_soldier = %Board.get_figures(Board.team.Black, Figure.Types.Soldier)
	if soldier.size() == 0:
		%Dialog.appear("You let the enemy pawn to destroy our guard…")
		await get_tree().create_timer(3).timeout
		reset()
		return
		
	if enemy_soldier.size() == 0:
		%Dialog.appear("You won, that's it for today :) ")
		return
	
	if soldier[0].board_position.y > enemy_soldier[0].board_position.y:
		%Dialog.appear("You let the enemy pawn to pass our guard…")
		await get_tree().create_timer(3).timeout
		reset()


func reset():
	%Dialog.appear("Please, try again.")
	var new_state: Dictionary = initial_state.duplicate()
	new_state[Vector2(4,7)] = {
		"type": Figure.Types.Soldier,
		"team": Board.team.Black,
		"group": "Cloud"
	}
	%Board.create_state(new_state)
	%PowerMeter.energy += FigureCard.figure_energies[Figure.Types.Soldier]
	%Garrison.set_figure_cards()


func _on_board_move_computer() -> void:
	$tutorial_engine.make_move()
	check_status()


func _on_dialog_finished(to_call: Callable) -> void:
	to_call.call()
