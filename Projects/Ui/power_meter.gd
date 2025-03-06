extends Control

signal energy_changed(energy: float)

@export var energy: float :
	set(e):
		energy = e
		$energy.value = energy
		emit_signal("energy_changed", energy)

@export var distance: int :
	set(d):
		distance = d
		for i in $distance_bars.get_children():
			i.value = min(d,i.max_value)
			d -= i.value

func _ready() -> void:
	energy = energy

func energy_highlight_visible(state):
	$energy/highlight.visible = state

func distance_highlight_visible(state):
	$distance_highlight.visible = state
