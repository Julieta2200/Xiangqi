extends Node2D

var state : Dictionary
var enemy_soldier : Figure

# 1. Scroll / Camera move
# 2. Enemy soldier appears
# 3. Add Soldier / Distance meter/ Energy meter
# 4. Use soldier to capture enemy Soldier
# 5. Create new soldier


func _ready():
	%Board.for_tutorial = true
	camera_zoom()

	state = {
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
	
func _on_camera_zoom() -> void:
	camera_movement()
	
func camera_zoom():
	%Dialog.appear("You can scroll to zoom in and out to have a better view of surroundings")

func camera_movement():
	%Dialog.appear("Use WASD to look around.")
	await get_tree().create_timer(3).timeout
	explain_energy()
	
func explain_energy():
	%Dialog.appear("Look! An enemy soldier is approaching.")
	var enemy_soldier = create_enemy_soldier()
	enemy_soldier.highlight.visible = true
	await get_tree().create_timer(3).timeout
	%Dialog.appear("We have a few soldiers with us, but you need to summon them.")
	await get_tree().create_timer(3).timeout
	enemy_soldier.highlight.visible = false
	%PowerMeter.energy_highlight_visible(true)
	%Dialog.appear("To summon a soldier you need to have enough energy.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("To get more energy you need to capture enemy soldiers.")
	%PowerMeter.energy_highlight_visible(false)
	explain_pawn_card()

func create_enemy_soldier() -> Figure:
	state = { Vector2(6, 6) : {
			"type": Figure.Types.Soldier,
			"team": Board.team.Black,
			"group": "Cloud"
		}
	}
	%Board.create_figures(state)
	return %Board.state[Vector2(6, 6)]

func explain_pawn_card():
	%Dialog.appear("Click on the pawn card to summon it.")
	%Garrison.check_selected_figure = true
	%Garrison.get_soldier_card().highlight.visible = true
	

func _on_garrison_click_soldier_card(selected_card: FigureCard) -> void:
	%Garrison.get_soldier_card().highlight.visible = false
	%Dialog.appear("The distance meter shows how far in the arena you can summon your soldiers.")
	%PowerMeter.distance_highlight_visible(true)
	await get_tree().create_timer(3).timeout
	%Dialog.appear("The more soldiers you have the longer the distance.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("You can’t summon a soldier inside the palace.")
	%PowerMeter.distance_highlight_visible(false)
	summon_soldier()

func summon_soldier():
	%Dialog.appear("Click on one of the markers to summon your soldier there.")
	%Board.check_marker_click = true


func _on_board_in_marker_click() -> void:
	%Dialog.appear("Now it’s our turn to move.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Click on a pawn to see all possible moves.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Pawns can move only forward, by one step, once they cross the river, they can also move one step horizontally.")
	await get_tree().create_timer(3).timeout
	%Dialog.appear("Capture the enemy pawn.")

func computer_move():
	await $tutorial_engine.make_move()
