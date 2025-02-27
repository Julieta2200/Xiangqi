extends Node2D


func _on_power_meter_energy_changed(energy: float) -> void:
	%Garrison.energy_changed(energy)
