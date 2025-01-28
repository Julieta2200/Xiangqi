extends ComputerEngine


func make_move() -> void:
	%Evaluation.evaluate_multithread(%Board.state, %Board.turn, 2)

