extends Node2D

var solder

func _ready():
	var state: Dictionary = {
		Vector2(5, 3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		},
	}
	
	
	%Board.create_state(state,true)
	solder = %Board.state[Vector2(5, 3)]
	soldier_movement_dialog()

func soldier_movement_dialog():
	%Dialog.appear("Before crossing the river, soldier can only move 1 position forward each step")
	solder.arrows.get_child(0).visible = true

func computer_move():
	await $tutorial_engine.make_move()
	await get_tree().create_timer(0.3).timeout 
	match %Board.move_number:
		1:
			solder.arrows.get_child(0).visible = true
			%Dialog.appear("Cross the river")
		2:
			for i in solder.arrows.get_children():
				i.visible = true
			%Dialog.appear("After crossing the river, soldier can move 1 position forward or sideways each step.Move in any of the directions.")
