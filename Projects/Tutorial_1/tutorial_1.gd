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
var part_start_point : int:
	set(p):
		part_start_point = p
		part += 1

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

func part_2_soldier_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(2,6), "Cloud", Board.team.Black, false, true)
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("A new pawn spawned.","Advisor", "Sprite"),
			TextBlock.new("Well someone is summoning them…","Ashes", "Sprite")]
	%Dialog.appear(texts)
	await get_tree().create_timer(3).timeout
	%Board.computer_move(Vector2(2,6), Vector2(2,5))
	%PowerMeter.filled_energy = 0
	%PowerMeter.filled_distance = 0

func advisor_make_active():
	%Board.state[Vector2(3,0)].active = true
	%Board.state[Vector2(5,0)].active = true

func explain_advisor():
	advisor_make_active()
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("You can use Advisors.","Advisor", "Sprite"),
			TextBlock.new("They move and capture one point diagonally and may not leave the palace.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	
func part_3_soldiers_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(3,2), "Cloud", Board.team.Black, false, true)
	%Board.set_figure(Figure.Types.Soldier, Vector2(4,2), "Cloud", Board.team.Black, false, true)
	%Board.set_figure(Figure.Types.Soldier, Vector2(5,2), "Cloud", Board.team.Black, false, true)
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("They are trying to surround us.","Advisor", "Sprite"),
			TextBlock.new("Stay calm, they’re just brainless pawns.","Ashes", "Sprite"),
			TextBlock.new("Attack my fearless Cloud Army.","Cloud General", "Sprite"),
			TextBlock.new("Fearless Cloud… sure…","Ashes", "Sprite")]
	%Dialog.appear(texts,explain_advisor)
	await get_tree().create_timer(3).timeout
	%Board.computer_move(Vector2(4,2), Vector2(4,1))
	%PowerMeter.filled_energy = 0


func explain_general():
	%Board.state[Vector2(4,0)].active = true
	var texts: Array[TextBlock] 
	texts = [TextBlock.new("You can use Genera.","Advisor", "Sprite"),
			TextBlock.new("The general may move and capture one point orthogonally and may not leave the palace.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	%PowerMeter.filled_energy = 0

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
				part_2_soldier_spawn()
				part_start_point = %Board.move_number
				return
			
			if soldier[0].board_position.y > enemy_soldier[0].board_position.y:
				var texts: Array[TextBlock] = [TextBlock.new("You let the enemy pawn to pass our guard…","Advisor", "Sprite")]
				%Dialog.appear(texts,reset_part_1)
				return
		2:
			var soldier = %Board.get_figures(Board.team.Red, Figure.Types.Soldier)
			var enemy_soldier = %Board.get_figures(Board.team.Black, Figure.Types.Soldier)
			if enemy_soldier.size() == 0:
				part_3_soldiers_spawn()
				%Board.move_number = 9
				part_start_point = %Board.move_number
				return
			match soldier.size():
				1:
					if $tutorial_engine.capture_figure:
						var texts: Array[TextBlock] = [TextBlock.new("You let your pawn be captured…","Advisor", "Sprite")]
						%Dialog.appear(texts,reset_part_2)
						return
					elif soldier[0].board_position.y > enemy_soldier[0].board_position.y:
						var texts: Array[TextBlock] = [TextBlock.new("You can’t catch her, Summon a new pawn.","Advisor", "Sprite")]
						%Dialog.appear(texts)
						return
				2:
					if soldier[1].board_position.y > enemy_soldier[0].board_position.y and soldier[0].board_position.y > enemy_soldier[0].board_position.y:
						var texts: Array[TextBlock] = [TextBlock.new("You let the enemy pawn to pass our guard…","Advisor", "Sprite")]
						%Dialog.appear(texts,reset_part_2)
						return
		3:
			var enemy_soldier = %Board.get_figures(Board.team.Black, Figure.Types.Soldier)
			if enemy_soldier[0].board_position.y == 0 and enemy_soldier.size() == 1:
				explain_general()
				part_start_point = %Board.move_number
				return
			if $tutorial_engine.capture_figure:
				var texts: Array[TextBlock] = [TextBlock.new("You let your figure be captured…","Advisor", "Sprite")]
				%Dialog.appear(texts,reset_part_3)
				return
		4:
			var enemy_soldier = %Board.get_figures(Board.team.Black, Figure.Types.Soldier)
			if enemy_soldier.size() == 0:
				var texts: Array[TextBlock] = [TextBlock.new("You won.","Advisor", "Sprite")]
				%Dialog.appear(texts)
				part_start_point = %Board.move_number
				return
			else:
				var texts: Array[TextBlock] = [TextBlock.new("The enemy pawn slipped from your control.","Advisor", "Sprite")]
				%Dialog.appear(texts,reset_part_4)
				return
				
			
func reset_part_4():
	var texts: Array[TextBlock] = [TextBlock.new("Please, try again.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	%Board.load_move(part_start_point) 
	%PowerMeter.reset()
	explain_general()
	
func reset_part_3():
	var texts: Array[TextBlock] = [TextBlock.new("Please, try again.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	%Board.load_move(part_start_point) 
	%PowerMeter.reset()
	advisor_make_active()

func reset_part_2():
	var texts: Array[TextBlock] = [TextBlock.new("Please, try again.","Advisor", "Sprite")]
	%Dialog.appear(texts)
	%Board.load_move(part_start_point)
	%PowerMeter.energy += FigureCard.figure_energies[Figure.Types.Soldier] 
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
	%Board.move_number = 0
	%PowerMeter.energy += FigureCard.figure_energies[Figure.Types.Soldier] 
	%PowerMeter.reset()
	

func _on_board_move_computer() -> void:
	$tutorial_engine.make_move()
	check_status()


func _on_dialog_finished(to_call: Callable) -> void:
	to_call.call()
