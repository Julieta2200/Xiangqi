extends Node2D

var state : Dictionary
var soldier: Figure 
var general: Figure
var adviser: Figure

func _ready():
	%Board.for_tutorial = true
	create_soldier()
	soldier_movement_dialog()
	
func create_soldier():
	state = {
		Vector2(5, 3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		}
	}
	
	%Board.create_state(state)
	%Board.generate_save_state()
	soldier = %Board.state[Vector2(5, 3)]

func create_general():
	delete_figure()
	state = {
		Vector2(4,0): {
			"type": Figure.Types.General,
			"team": Board.team.Red
		}
	}
	%Board.create_state(state)
	%Board.generate_save_state()
	general =  %Board.state[Vector2(4, 0)]
	for i in general.arrows.get_children():
		i.visible = true

func create_adviser_for_general():
	delete_figure()
	state = {
		Vector2(5,0): {
			"type": Figure.Types.General,
			"team": Board.team.Red
		},
		Vector2(4,0): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive": true
		}
	}
	%Board.create_state(state)
	%Board.generate_save_state()
	general =  %Board.state[Vector2(5, 0)]

func create_adviser():
	delete_figure()
	state = {
		Vector2(4,1): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
		}
	}
	%Board.create_state(state)
	%Board.generate_save_state()
	adviser =  %Board.state[Vector2(4, 1)]
	for i in adviser.arrows.get_children():
		i.visible = true


func create_black_general():
	delete_figure()
	state = {
		Vector2(5,2): {
			"type": Figure.Types.General,
			"team": Board.team.Red
		},
		Vector2(4,1): {
			"type": Figure.Types.Advisor,
			"team": Board.team.Red,
			"inactive": true
		},
		Vector2(4,9): {
			"type": Figure.Types.General,
			"team": Board.team.Black
		}
	}
	%Board.create_state(state)
	%Board.generate_save_state()


func soldier_movement_dialog():
	%Dialog.appear("Before crossing the river, soldier can only move 1 position forward each step")
	soldier.arrows.get_child(0).visible = true

func delete_figure():
	%Board.unhighlight_markers()
	for i in %Board.state.keys():
		%Board.state[i].delete()
		%Board.state.erase(i)


func computer_move():
	await $tutorial_engine.make_move()
	match %Board.move_number:
		1:
			soldier.arrows.get_child(0).visible = true
			%Dialog.appear("Cross the river")
		2:
			for i in soldier.arrows.get_children():
				i.visible = true
			%Dialog.appear("After crossing the river, soldier can move 1 position forward or sideways each step.Move in any of the directions.")
		3:
			create_general()
			%Board.markers[Vector2(5, 0)].highlighted_spot.visible = true
			%Dialog.appear("General can't leave palace.And moves vertically and horizontally to one position․Move to the right")
		4:
			if !%Board.state.has(Vector2(5,0)):
				%Dialog.appear("Move to the right")
				delete_figure()
				%Board.load_move(3)
				return
			else:
				create_adviser_for_general()
				%Board.markers[Vector2(5, 0)].highlighted_spot.visible = false
				%Board.markers[Vector2(4, 1)].highlighted_spot.visible = true
				%Dialog.appear("Move the red general to the highlighted spot in 2 moves")
		6:
			if !%Board.state.has(Vector2(4,1)):
				%Dialog.appear("Move the red general to the highlighted spot in 2 moves")
				delete_figure()
				%Board.load_move(4) 
				return
			else:
				create_black_general()
				%Board.markers[Vector2(4, 1)].highlighted_spot.visible = false
				%Board.markers[Vector2(3, 2)].highlighted_spot.visible = true
				%Dialog.appear("Due to the /Flying General Rule/, two generals can't be placed on the same file without any pieces in between.How can the red general move to the highlighted spot?")
		7:
			if %Board.state.has(Vector2(4,2)):
				%Dialog.appear("Due to the /Flying General Rule/, two generals can't be placed on the same file without any pieces in between.")
				delete_figure()
				%Board.load_move(6)
				return
		12:
			if !%Board.state.has(Vector2(3,2)):
				delete_figure()
				%Dialog.appear("Move the red general to the highlighted spot in 5 moves")
				%Board.load_move(6)
				return
			else:
				create_adviser()
				%Board.markers[Vector2(3, 2)].highlighted_spot.visible = false
				%Board.markers[Vector2(5, 0)].highlighted_spot.visible = true
				%Dialog.appear("Move the advisor to the highlighted spot.")
		13:
			if !%Board.state.has(Vector2(5,0)):
				%Dialog.appear("Move the advisor to the highlighted spot.")
				delete_figure()
				%Board.load_move(12)
				return
			else:
				pass
