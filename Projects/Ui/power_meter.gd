class_name PowerMeter extends Control

@export var garrison: Garrison

# amount of energy added after each step
@export var energy_fill: int = 7
const max_energy: int = 100
		

# Stores the energy value and updates the energy display while emitting a signal when it changes
@export var energy: float :
	set(e):
		e = clamp(e, 0, max_energy)
		energy = e
		$current_energy.value = energy
		$NumberLabel.text = str(energy) + "%"

func fill_energy():
	energy += energy_fill
	garrison.update_cards(energy)

func substruct_energy():
	energy -= garrison.selected_figure.energy
	garrison.update_cards(energy)
