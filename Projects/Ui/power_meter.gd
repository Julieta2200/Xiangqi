extends Control

signal energy_changed(energy: float)

# the amount of energy added during the game
var filled_energy: int = 0

# the amount of distance added during the game
var filled_distance: int = 0

# the full extent of the playing distance
var distance_bar :int = 10

# amount of energy added after each step
@export var energy_bar: int = 5

# Stores the energy value and updates the energy display while emitting a signal when it changes
@export var energy: float :
	set(e):
		energy = e
		$energy.value = energy
		emit_signal("energy_changed", energy)

# Stores the distance value and updates the visibility of distance bars based on the value
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
	filled_energy += energy_bar
	energy += energy_bar

func fill_distance():
	filled_distance += distance_bar
	distance += distance_bar

# Resets to the original form
func reset():
	energy -= filled_energy
	distance -= filled_distance
	filled_energy = 0
	filled_distance = 0
