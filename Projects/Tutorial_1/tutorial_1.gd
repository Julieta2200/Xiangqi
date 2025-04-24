extends Node2D

var initial_state = {
		Vector2(4, 0): {
			"type": Figure.Types.General,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
		Vector2(3, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
		Vector2(5, 0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive" : false,
			"group": "Magma"
		},
	}

var first_time: bool = true
var part: int = 1
var part_start_point : int

func _ready():
	camera_zoom()
	
	%Board.create_state(initial_state)

func camera_zoom():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("You can scroll to zoom in and out to have a better view of surroundings (If mouse scroll doesn't work please use Q,E keys, sorry we're still developing :) )","Advisor", "Sprite")]
	%Dialog.appear(texts,camera_movement)

func camera_movement():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Use W, A, S, D to look around.","Advisor", "Sprite")]
	%Dialog.appear(texts,look_out)

func look_out():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Look! An enemy soldier is approaching.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	$Camera/AnimationPlayer.play("enemy_spawn")

func soldier_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(4,7), "Cloud", Board.team.Black, false, true)
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Don’t go any further!!!","Pawn", "Sprite")]
	%Dialog.appear(texts,spawn_garrison)
	await get_tree().create_timer(3).timeout
	$Camera/AnimationPlayer.play("RESET")

func spawn_garrison():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("We have a few soldiers with us, but you need to summon them.","Advisor", "Sprite"),
			TextBlock.new("To summon a soldier you need to have enough energy.","Advisor", "Sprite"),
			TextBlock.new("To get more energy you need to capture enemy soldiers.","Advisor", "Sprite")]
	%Dialog.appear(texts,explain_pawn_card)
	await get_tree().create_timer(4).timeout
	%PowerMeter.show_energy_bar()

	
func explain_pawn_card():
	%Garrison.show()
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Click on the pawn card to summon it.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	%Garrison.get_soldier_card().highlight()
	await get_tree().create_timer(3).timeout
	%Garrison.get_soldier_card().unhighlight()

func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	if first_time:
		summon_soldier()

func summon_soldier():
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("The distance meter shows how far in the arena you can summon your soldiers.","Advisor", "Sprite"),
			TextBlock.new("The more soldiers you have the longer the distance. You can’t summon a soldier inside the palace.","Advisor","Sprite"),
			TextBlock.new("Click on one of the markers to summon your soldier there.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	%PowerMeter.show_distance_bar()

func _on_board_set_figure(marker: BoardMarker) -> void:
	if first_time:
		move_and_capture_enemy()

func move_and_capture_enemy() -> void:
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Now it’s our turn to move.","Advisor", "Sprite"),
			TextBlock.new("Click on a pawn to see all possible moves.","Advisor", "Sprite"),
			TextBlock.new("Pawns can move only forward, by one step, once they cross the river, they can also move one step horizontally.","Advisor", "Sprite"),
			TextBlock.new("Capture the enemy pawn.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	first_time = false


func part_2_capture_enemy() -> void:
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("The enemy has placed another pawn.","Advisor", "Sprite"),
			TextBlock.new("Capture the enemy pawn too.","Advisor", "Sprite")]
	%Dialog.appear(texts)

func part_2_soldier_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(2,6), "Cloud", Board.team.Black, false, true)
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("Don’t go!","Pawn", "Sprite")]
	%Dialog.appear(texts,part_2_capture_enemy)
	await get_tree().create_timer(3).timeout
	%Board.computer_move(Vector2(2,6), Vector2(2,5))


func check_status():
	match part:
		1:
			var soldier = %Board.get_figures(Board.team.Red, Figure.Types.Soldier)
			var enemy_soldier = %Board.get_figures(Board.team.Black, Figure.Types.Soldier)
			if soldier.size() == 0:
				var texts: Array[TextBlock] = [TextBlock.new("You let the enemy pawn to destroy our guard…","Advisor", "Sprite")]
				%Dialog.appear(texts,reset_part_1)
				return
				
			if enemy_soldier.size() == 0:
				var texts: Array[TextBlock] = [TextBlock.new("Great Job!","Advisor", "Sprite")]
				%Dialog.appear(texts,part_2_soldier_spawn)
				part_start_point = %Board.move_number
				part += 1
				return
			
			if soldier[0].board_position.y > enemy_soldier[0].board_position.y:
				var texts: Array[TextBlock] = [TextBlock.new("You let the enemy pawn to pass our guard…","Advisor", "Sprite")]
				%Dialog.appear(texts,reset_part_1)
				return
		2:
			var soldier = %Board.get_figures(Board.team.Red, Figure.Types.Soldier)
			var enemy_soldier = %Board.get_figures(Board.team.Black, Figure.Types.Soldier)
			if enemy_soldier.size() == 0:
				var texts: Array[TextBlock] = [TextBlock.new("Great Job!","Advisor", "Sprite")]
				%Dialog.appear(texts)
				part += 1
				return
			match soldier.size():
				1:
					if soldier[0].board_position.y > enemy_soldier[0].board_position.y:
						var texts: Array[TextBlock] = [TextBlock.new("You let the enemy pawn to destroy our guard, add another soldier","Advisor", "Sprite")]
						%Dialog.appear(texts)
						return
				2:
					if soldier[1].board_position.y > enemy_soldier[0].board_position.y:
						var texts: Array[TextBlock] = [TextBlock.new("You let go of the enemy soldier","Advisor", "Sprite")]
						%Dialog.appear(texts,reset_part_2)
						return
			if enemy_soldier[0].board_position.y <= 0:
				var texts: Array[TextBlock] = [TextBlock.new("Your soldier can no longer capture an enemy.","Advisor", "Sprite")]
				%Dialog.appear(texts,reset_part_2)
				return
		
		
func reset_part_2():
	var texts: Array[TextBlock] = [TextBlock.new("Please, try again.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	%Board.load_move(part_start_point)
	%PowerMeter.energy += 2 * FigureCard.figure_energies[Figure.Types.Soldier] 
	%PowerMeter.reset()

func reset_part_1():
	var texts: Array[TextBlock] = [TextBlock.new("Please, try again.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	var new_state: Dictionary = initial_state.duplicate()
	new_state[Vector2(4,7)] = {
		"type": Figure.Types.Soldier,
		"team": Board.team.Black,
		"group": "Cloud"
	} 
	%Board.create_state(new_state)
	%PowerMeter.energy += FigureCard.figure_energies[Figure.Types.Soldier] 
	%PowerMeter.reset()
	

func _on_board_move_computer() -> void:
	$tutorial_engine.make_move()
	check_status()


func _on_dialog_finished(to_call: Callable) -> void:
	to_call.call()
