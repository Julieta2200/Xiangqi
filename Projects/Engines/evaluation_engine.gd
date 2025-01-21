extends ComputerEngine

func make_move() -> void:
	await get_tree().create_timer(1).timeout 
	%Evaluation.evaluate(%Board.state, %Board.turn, 3)
	var best_move: Dictionary = %Evaluation.best_move
	%Board.computer_move(best_move.pos, best_move.new_pos)
