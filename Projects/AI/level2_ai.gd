extends AIV2

const black_horse_value: int = 24

func _ready() -> void:
    super._ready()
    figure_values[4] = 1000000

func get_all_legal_moves(team: int, position: Array[Array]) -> Array[Array]:
    var legal_moves: Array[Array] = []
    if team == 1:
        return super.get_all_legal_moves(team_numbers[BoardV2.Teams.Black], position)
    
    for y in position.size():
        for x in position[y].size():
            if position[y][x] != black_horse_value:
                continue
            legal_moves.append_array(figure_legal_moves[4].call(team, position, y, x))
    return legal_moves