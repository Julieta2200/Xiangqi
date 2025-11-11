class_name PowerMeter extends Control

signal energy_depleted

@export var garrison: Garrison

# amount of energy added after each step
@export var energy_fill: int = 7
const max_energy: int = 100
		

# Stores the energy value and updates the energy display while emitting a signal when it changes
@export var energy: float :
	set(e):
		e = clamp(e, 0, max_energy)
		if e == 0:
			emit_signal("energy_depleted")
		energy = e
		altered_energy = energy
		current_energy =  energy
		$altered_energy/Label.text = str(energy) + " / " + str(max_energy)

var altered_energy: float:
	set(e):
		altered_energy = e
		$altered_energy.value = altered_energy

var current_energy: float:
	set(e):
		current_energy = e
		$current_energy.value = current_energy

func show_energy_preview():
	altered_energy -= garrison.selected_figure.energy

func hide_energy_preview():
	if energy != 0:
		energy = energy

func fill_energy():
	energy += energy_fill
	garrison.update_cards(energy)

func substruct_energy():
	energy -= garrison.selected_figure.energy
	garrison.update_cards(energy)

func discharge_energy():
	energy -= energy_fill
	garrison.update_cards(energy)
