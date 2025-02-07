extends Soldier

func _ready():
	
	boundaries = {
		Board.team.Red: {
			"y": Vector2(0, 9),
			"x": Vector2(0, 8)
		},
		Board.team.Black: {
			"y": Vector2(0, 9),
			"x": Vector2(0, 8)
		}
	}
