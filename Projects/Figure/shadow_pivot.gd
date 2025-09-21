extends Node2D

@export var shadow: AnimatedSprite2D
const flip_limit = 70
const flip_limit2 = 240

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotate the node at a constant speed (e.g., 90 degrees per second)
	rotation = ShadowController.rotation
	if shadow == null:
		return
	if rotation_degrees > flip_limit and rotation_degrees < flip_limit2:
		shadow.flip_h = true
	else:
		shadow.flip_h = false
