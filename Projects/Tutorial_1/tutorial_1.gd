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
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("You can scroll to zoom in and out to have a better view of surroundings (If mouse scroll doesn't work please use Q,E keys, sorry we're still developing :) )","Name", "Sprite")]
	%Dialog.appear(texts,camera_movement)

func camera_movement():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Use W, A, S, D to look around.","Name", "Sprite")]
	%Dialog.appear(texts,look_out)

func look_out():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Look! An enemy soldier is approaching.","Name", "Sprite")]
	$Camera/AnimationPlayer.play("enemy_spawn")

func soldier_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(4,7), "Cloud", Board.team.Black)
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Don’t go any further!!!","Name", "Sprite")]
	%Dialog.appear(texts,spawn_garrison)
	await get_tree().create_timer(3).timeout
	$Camera/AnimationPlayer.play("RESET")

func spawn_garrison():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("We have a few soldiers with us, but you need to summon them.","Name", "Sprite"),
			TextBlock.new("To summon a soldier you need to have enough energy.","Name", "Sprite"),
			TextBlock.new("To get more energy you need to capture enemy soldiers.","Name", "Sprite")]
	%Dialog.appear(texts,explain_pawn_card)
	await get_tree().create_timer(4).timeout
	%PowerMeter.show_energy_bar()

	
func explain_pawn_card():
	%Garrison.show()
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Click on the pawn card to summon it.","Name", "Sprite")]
	%Dialog.appear(texts)
	%Garrison.get_soldier_card().highlight()
	await get_tree().create_timer(3).timeout
	%Garrison.get_soldier_card().unhighlight()

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	if first_time:
		summon_soldier()

func summon_soldier():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("The distance meter shows how far in the arena you can summon your soldiers.","Name", "Sprite"),
			TextBlock.new("The more soldiers you have the longer the distance. You can’t summon a soldier inside the palace.","Name", "Sprite"),
			TextBlock.new("Click on one of the markers to summon your soldier there.","Name", "Sprite")]
	%Dialog.appear(texts)

func _on_board_set_figure(marker: BoardMarker) -> void:
	if first_time:
		move_and_capture_enemy()

func move_and_capture_enemy() -> void:
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Now it’s our turn to move.","Name", "Sprite"),
			TextBlock.new("Click on a pawn to see all possible moves.","Name", "Sprite"),
			TextBlock.new("Pawns can move only forward, by one step, once they cross the river, they can also move one step horizontally.","Name", "Sprite"),
			TextBlock.new("Capture the enemy pawn.","Name", "Sprite"),]
	%Dialog.appear(texts)
	first_time = false


func check_status():
	var soldier = %Board.get_figures(Board.team.Red, Figure.Types.Soldier)
	var enemy_soldier = %Board.get_figures(Board.team.Black, Figure.Types.Soldier)
	if soldier.size() == 0:
		var texts: Array[TextBlock] = [TextBlock.new("You let the enemy pawn to destroy our guard…","Name", "Sprite")]
		%Dialog.appear(texts,reset)
		return
		
	if enemy_soldier.size() == 0:
		var texts: Array[TextBlock] = [TextBlock.new("You won, that's it for today :) ","Name", "Sprite")]
		%Dialog.appear(texts)
		return
	
	if soldier[0].board_position.y > enemy_soldier[0].board_position.y:
		var texts: Array[TextBlock] = [TextBlock.new("You let the enemy pawn to pass our guard…","Name", "Sprite")]
		%Dialog.appear(texts,reset)
		return


func reset():
	var texts: Array[TextBlock] = [TextBlock.new("Please, try again.","Name", "Sprite")]
	%Dialog.appear(texts)
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
