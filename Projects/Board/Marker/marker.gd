extends Node2D


func _on_area_2d_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		if $highlight.visible:
			$"../../..".move(self)


func highlight():
	$highlight.visible = true

func unhighlight():
	$highlight.visible = false
