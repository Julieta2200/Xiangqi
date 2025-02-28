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
			i.value = min(distance,i.max_value)
			distance -= i.value

func _ready() -> void:
	energy = energy


func _process(delta: float) -> void:
	pass
