extends Node2D


func _on_power_meter_energy_changed(energy: float) -> void:
	%Garrison.energy_changed(energy)

func free_markers_highlight():
	var distance_rows = %PowerMeter.distance / 10 - 1

	for i in %Board.markers:
		if i.y >= 7 and i.x >= 3 and i.x <= 5:
			continue
			
		if !%Board.state.has(i) and  i.y <=  distance_rows:
			%Board.markers[i].free_marker_highlight.visible = true
		
