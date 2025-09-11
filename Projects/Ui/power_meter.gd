class_name PowerMeter extends Control

signal energy_depleted

@export var garrison: Garrison
# the full extent of the playing distance
@export var distance_fill :int = 1

# amount of energy added after each step
@export var energy_fill: int = 7

var max_energy: int :
	set(e):
		max_energy = e
		$energy.max_value = max_energy
		energy = max_energy
		

# Stores the energy value and updates the energy display while emitting a signal when it changes
@export var energy: float :
	set(e):
		if e <= 0:
			e = 0
			emit_signal("energy_depleted")
		energy = e
		$energy.value = energy
		$energy/Label.text = str(energy) + " / " + str(max_energy)

# Stores the distance value and updates the visibility of distance bars based on the value
@export var distance: int :
	set(d):
		if d < 0:
			d = 0
		distance = d
		for i in $distances/distance_bars.get_children():
			if d >= distance_fill:
				d -= min(distance,distance_fill)
				i.visible = true
			else:
				i.visible = false

func _ready() -> void:
	max_energy = GameState.state["energy"]

func fill_energy():
	energy += energy_fill
	garrison.update_cards(energy)

func update_distance(num: int):
	distance = num/3

func substruct_energy():
	energy -= garrison.selected_figure.energy
	garrison.update_cards(energy)

func discharge_energy():
	energy -= energy_fill
	garrison.update_cards(energy)
