extends Node2D

var state : Dictionary
var soldier
var general
var adviser 

func _ready():
	%Board.for_tutorial = true
	soldier_create()
	soldier_movement_dialog()
	
func soldier_create():
	state = {
		Vector2(5, 3): {
			"type": Figure.Types.Soldier,
			"team": Board.team.Red
		}
	}
	
	%Board.create_state(state)
	soldier = %Board.state[Vector2(5, 3)]

func general_create():
	%Board.unhighlight_markers()
	for i in %Board.state:
		%Board.state[i].delete()
		%Board.state.erase(i)
	state = {
		Vector2(4,0): {
			"type": Figure.Types.General,
			"team": Board.team.Red
		}
	}
	%Board.create_state(state)
	general =  %Board.state[Vector2(4, 0)]
	for i in general.arrows.get_children():
		i.visible = true

func creat_adviser():
	%Board.unhighlight_markers()
	for i in %Board.state:
		%Board.state[i].delete()
		%Board.state.erase(i)
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
	general =  %Board.state[Vector2(5, 0)]

func create_black_general():
	%Board.unhighlight_markers()
	for i in %Board.state:
		%Board.state[i].delete()
		%Board.state.erase(i)
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
	general =  %Board.state[Vector2(5, 2)]

func soldier_movement_dialog():
	%Dialog.appear("Before crossing the river, soldier can only move 1 position forward each step")
	soldier.arrows.get_child(0).visible = true

func computer_move():
	await $tutorial_engine.make_move()
	await get_tree().create_timer(0.3).timeout 
	match %Board.move_number:
		1:
			%Board.generate_save_state()
			soldier.arrows.get_child(0).visible = true
			%Dialog.appear("Cross the river")
		2:
			%Board.generate_save_state()
			for i in soldier.arrows.get_children():
				i.visible = true
			%Dialog.appear("After crossing the river, soldier can move 1 position forward or sideways each step.Move in any of the directions.")
		3:
			general_create()
			%Board.generate_save_state()
			%Board.markers[Vector2(5, 0)].highlighted_spot.visible = true
			%Dialog.appear("General can't leave palace.And moves vertically and horizontally to one position․Move to the right")
		4:
			if !general.board_position == Vector2(5, 0):
				%Dialog.appear("Move to the right")
				await get_tree().create_timer(1).timeout
				%Board.load_move(3) 
				return
			else:
				creat_adviser()
				%Board.generate_save_state()
				%Board.markers[Vector2(5, 0)].highlighted_spot.visible = false
				%Board.markers[Vector2(4, 1)].highlighted_spot.visible = true
				%Dialog.appear("Move the red general to the highlighted spot in 2 moves")
		6:
			if !general.board_position == Vector2(4, 1):
				%Dialog.appear("Move the red general to the highlighted spot in 2 moves")
				await get_tree().create_timer(1).timeout
				%Board.load_move(4) 
				return
			else:
				%Board.markers[Vector2(4, 1)].highlighted_spot.visible = false
				create_black_general()
				%Board.generate_save_state()
				%Board.markers[Vector2(3, 2)].highlighted_spot.visible = true
				%Dialog.appear("Due to the /Flying General Rule/, two generals can't be placed on the same file without any pieces in between.How can the red general move to the highlighted spot?")
		7:
			if general.board_position == Vector2(4, 2):
				%Dialog.appear("Due to the /Flying General Rule/, two generals can't be placed on the same file without any pieces in between.")
				await get_tree().create_timer(1).timeout
				%Board.load_move(6)
				return
			
			
			
