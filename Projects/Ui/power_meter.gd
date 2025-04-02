extends Control

signal energy_changed(energy: float)
var distance_bar :int = 10

@export var energy: float :
	set(e):
		energy = e
		$energy.value = energy
		emit_signal("energy_changed", energy)

@export var distance: int :
	set(d):
		distance = d
		for i in $distances/distance_bars.get_children():
			if d >= distance_bar:
				d -= min(distance,distance_bar)
				i.visible = true

func _ready() -> void:
	energy = energy

func show_energy_bar():
	$energy.show()
	$energy/AnimationPlayer.play("highlight")

func show_distance_bar():
	$distances.show()
	$distances/AnimationPlayer.play("highlight")
	
func fill_energy():
	energy += 5

func fill_distance():
	distance += 10
	
