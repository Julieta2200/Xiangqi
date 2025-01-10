extends Node2D

@onready var highlight = $highlight


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		if $highlight.visible:
			$"../../..".state_fix(self)
