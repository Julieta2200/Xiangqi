extends Control


func _ready() -> void:
	$TextureRect/Count.text = str(GameState.state.orbs)

	
	
