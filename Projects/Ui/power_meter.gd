class_name PowerMeter extends Control

signal energy_depleted

@export var garrison: Garrison

# amount of energy added after each step
@export var energy_fill: int = 7
const max_energy: int = 100
		

# Stores the energy value and updates the energy display while emitting a signal when it changes
@export var energy: float :
	set(e):
		if e <= 0:
			e = 0
			emit_signal("energy_depleted")
		energy = e
		if energy > max_energy:
			energy = max_energy
		$energy.value = energy
		$energy/Label.text = str(energy) + " / " + str(max_energy)

func fill_energy():
	energy += energy_fill
	garrison.update_cards(energy)

func substruct_energy():
	energy -= garrison.selected_figure.energy
	garrison.update_cards(energy)

func discharge_energy():
	energy -= energy_fill
	garrison.update_cards(energy)
