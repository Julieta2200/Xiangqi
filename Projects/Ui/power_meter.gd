extends Control

signal energy_changed(energy: float)

@export var energy: float :
	set(e):
		energy = e
		$energy.value = energy
		emit_signal("energy_changed", energy)

@export var distance: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	energy = energy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
