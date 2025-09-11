class_name DisconnectionMist extends Node2D

var target_team: BoardV2.Teams
var countdown: int = 3

func activate(board: BoardV2) -> void:
	for pos in board.state:
		if board.state[pos].chess_component.team == target_team:
			match target_team:
				BoardV2.Teams.Red:
					if pos.y < 5:
						continue
				BoardV2.Teams.Black:
					if pos.y > 4:
						continue
			if board.state[pos].ui_component != null:
				board.state[pos].ui_component.active = false
			board.state[pos].frozen = true

func deactivate(board: BoardV2) -> void:
	countdown -= 1
	if countdown != 0:
		return
	for pos in board.state:
		if board.state[pos].chess_component.team != target_team:
			continue
		match target_team:
			BoardV2.Teams.Red:
				if pos.y < 5:
					continue
			BoardV2.Teams.Black:
				if pos.y > 4:
					continue
		if board.state[pos].ui_component != null:
			board.state[pos].ui_component.active = true
		board.state[pos].frozen = false
	board._mist = null
	$AnimationPlayer.play("remove")

func remove() -> void:
	queue_free()
