extends Control

@export var freeze_chance: float = 0.5

signal freeze(chance: float)
signal wall()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_freeze_gui_input(event: InputEvent) -> void:
	if !event.is_action_pressed("click"):
		return
	
	emit_signal("freeze", freeze_chance)
	
func activate(result: bool) -> void:
	visible = result


func _on_wall_gui_input(event: InputEvent) -> void:
	if !event.is_action_pressed("click"):
		return
	
	emit_signal("wall")
