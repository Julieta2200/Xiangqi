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
			if i == $distance_bars/AnimationPlayer:
				continue
			i.value = min(d,i.max_value)
			d -= i.value

func _ready() -> void:
	energy = energy

func show_energy_bar():
	$energy.show()
	$energy/AnimationPlayer.play("highlight")

func show_distance_bar():
	$distance_bars.show()
	$distance_bars/AnimationPlayer.play("highlight")
