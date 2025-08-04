extends Control

@export var freeze_chance: float = 0.5
@export var cooldown: int = 2

signal freeze(chance: float)

var freeze_active : bool 
var freeze_number: int = 1:
	set(f):
		freeze_number = f
		if f <= cooldown:
			freeze_active = true
		elif f < cooldown * 2:
			freeze_active = false
		else:
			freeze_number = 0
			

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
	if freeze_active:
		visible = result
