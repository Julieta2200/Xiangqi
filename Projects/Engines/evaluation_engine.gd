extends ComputerEngine


func make_move() -> void:
	%Board._counter = 0
	%Evaluation.evaluate_multithread(%Board.state, %Board.turn, 1)
