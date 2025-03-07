extends Node2D

func _ready():
	camera_zoom()
	var state = {
		Vector2(4, 0): {
			"type": Figure.Types.General,
			"team": Board.team.Red,
			"group": "Magma"
		},
		Vector2(3, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"group": "Magma"
		},
		Vector2(5, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"group": "Magma"
		},
	}
	
	%Board.create_state(state)

func camera_zoom():
	%Dialog.appear("You can scroll to zoom in and out to have a better view of surroundings")
	$ZoomTimer.start()

func _on_zoom_timer_timeout() -> void:
	camera_movement()

func camera_movement():
	%Dialog.appear("Use W, A, S, D to look around.")
	$MovementTimer.start()

func _on_movement_timer_timeout() -> void:
	look_out()

func look_out():
	%Dialog.appear("Look! An enemy soldier is approaching.")
	$Camera/AnimationPlayer.play("enemy_spawn")

func soldier_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(4,6), "Cloud", Board.team.Black)
	%Dialog.appear("Don’t go any further!!!")
	$GarrisonSpawnTimer.start()

func _on_garrison_spawn_timer_timeout() -> void:
	$Camera/AnimationPlayer.play("RESET")
	spawn_garrison()

func spawn_garrison():
	%Dialog.appear("We have a few soldiers with us, but you need to summon them.")
	%Garrison.show()
	await get_tree().create_timer(3).timeout
	%PowerMeter.show_energy_bar()
	%Dialog.appear("To summon a soldier you need to have enough energy.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("To get more energy you need to capture enemy soldiers.")
	explain_pawn_card()


func explain_pawn_card():
	%Dialog.appear("Click on the pawn card to summon it.")
	%Garrison.get_soldier_card().highlight()
	await get_tree().create_timer(3).timeout
	%Garrison.get_soldier_card().unhighlight()

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	summon_soldier()

func summon_soldier():
	%Dialog.appear("The distance meter shows how far in the arena you can summon your soldiers.")
	%PowerMeter.show_distance_bar()
	await get_tree().create_timer(3).timeout
	%Dialog.appear("The more soldiers you have the longer the distance.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("You can’t summon a soldier inside the palace.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Click on one of the markers to summon your soldier there.")


func _on_board_set_figure(marker: BoardMarker) -> void:
	move_and_capture_enemy()

func move_and_capture_enemy() -> void:
	%Dialog.appear("Now it’s our turn to move.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Click on a pawn to see all possible moves.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Pawns can move only forward, by one step, once they cross the river, they can also move one step horizontally.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Capture the enemy pawn.")


func computer_move():
	await $tutorial_engine.make_move()
