extends ComputerEngine

# initial - 5.40292501449585
# first opt - 4.83657693862915
# second opt - 4.40247201919556
# third opt - 2.92029809951782

func make_move() -> void:
	
	var eval: float = %Evaluation.evaluate_single_state(%Board.state)
	
	%Evaluation.state_hashes = {}
	%Evaluation.evaluate_multithread(%Board.state, eval, %Board.turn, 3)
	
#	%Board.computer_move(best_move.move.pos, best_move.move.new_pos)
