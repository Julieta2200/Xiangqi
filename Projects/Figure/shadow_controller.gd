extends Node

var rotation: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += deg_to_rad(25) * delta
	rotation = fmod(rotation, TAU)  # Keep rotation within 0 to 2*PI
