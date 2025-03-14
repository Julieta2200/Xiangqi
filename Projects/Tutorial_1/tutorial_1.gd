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

var camera_movment_dialogs: Array[Dictionary] = [
	{"name": "Advisor","text": "You can scroll to zoom in and out to have a better view of surroundings"},
	{"name": "Advisor","text": "Use WASD to look around."},
]

var soldier_spawn_dialogs: Array[Dictionary] = [
	{"name": "Advisor", "text": "Look! An enemy soldier is approaching."},
	{"name": "Advisor","text": "Don’t go any further!!!"},
]

var explain_energy_dialogs: Array[Dictionary] = [
	{"name": "Advisor","text": "We have a few soldiers with us, but you need to summon them."},
	{"name": "Advisor", "text": "To summon a soldier you need to have enough energy."},
	{"name": "Advisor", "text": "To get more energy you need to capture enemy soldiers."},
]
var explain_pawn_card_dialogs: Array[Dictionary] = [
	{"name": "Advisor", "text": "Click on the pawn card to summon it."},
]

var explain_distance_dialogs: Array[Dictionary] = [
	{"name": "Advisor", "text": "The distance meter shows how far in the arena you can summon your soldiers."},
	{"name": "Advisor", "text":  "The more soldiers you have the longer the distance."},
	{"name": "Advisor", "text": "You can’t summon a soldier inside the palace."},
	{"name": "Advisor", "text": "Click on one of the markers to summon your soldier there."},
]

var move_and_capture_enemy_dialogs: Array[Dictionary] = [
	{"name": "Advisor", "text": "Now it’s our turn to move."},
	{"name": "Advisor", "text": "Click on a pawn to see all possible moves."},
	{"name": "Advisor", "text":  "Pawns can move only forward, by one step, once they cross the river, they can also move one step horizontally."},
	{"name": "Advisor", "text": "Capture the enemy pawn."},
]
var dialog_index : int = 0 :
	set(i):
		dialog_index = i
		if current_function != null:
			current_function.call()
		
var first_time: bool = true
var current_function

func _ready():
	current_function = camera_movment
	camera_movment()
	%Board.create_state(initial_state)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip"):
		dialog_index += 1

func next_dialog(dialogs,next_func):
	if dialog_index == dialogs.size() -1 :
		current_function = next_func
		dialog_index = 0
		return
	
	$CanvasLayer/Dialog.talk(dialogs[dialog_index]["text"],dialogs[dialog_index]["name"])
	
func camera_movment():
	next_dialog(camera_movment_dialogs,enemy_soldier_spawn)


func enemy_soldier_spawn():
	next_dialog(soldier_spawn_dialogs,explain_energy)
	if dialog_index == 0:
		$Camera/AnimationPlayer.play("enemy_spawn")

func soldier_spawn():
	%Board.set_figure(Figure.Types.Soldier, Vector2(4,7), "Cloud", Board.team.Black)
	$GarrisonSpawnTimer.start()

func _on_garrison_spawn_timer_timeout() -> void:
	$Camera/AnimationPlayer.play("RESET")

func explain_energy():
	next_dialog(explain_energy_dialogs,explain_pawn_card)
	if dialog_index == 1:
		%PowerMeter.show_energy_bar()

func explain_pawn_card():
	next_dialog(explain_pawn_card_dialogs,explain_distance)
	%Garrison.show()
	%Garrison.get_soldier_card().highlight()
	await get_tree().create_timer(3).timeout
	%Garrison.get_soldier_card().unhighlight()
		
		
func _on_garrison_card_selected(selected_card: FigureCard) -> void:
	if first_time:
		dialog_index += 1
		
func explain_distance():
	next_dialog(explain_distance_dialogs,move_and_capture_enemy)
	if dialog_index == 1:
		%PowerMeter.show_distance_bar()


func _on_board_set_figure(marker: BoardMarker) -> void:
	if first_time:
		dialog_index += 1

func move_and_capture_enemy() -> void:
	next_dialog(move_and_capture_enemy_dialogs,null)
	if dialog_index == 0:
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
