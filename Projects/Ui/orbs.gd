extends Control


func _ready() -> void:
	$Count.text = str(GameState.state.orbs)

	
	
