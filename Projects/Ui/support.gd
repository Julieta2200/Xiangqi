extends Control

@export var freeze_chance: float = 0.5

signal freeze(chance: float)
signal wall()
signal destroy_wall()

var freeze_active: bool = true
var freeze_counter: int : 
	set(fc):
		if fc < 0:
			fc = 0
		freeze_counter = fc
		freeze_active = freeze_counter == 0

@export var freeze_counter_limit: int = 2

var wall_active: bool = true
var wall_counter: int :
	set(wc):
		if wc < 0:
			wc = 0
		wall_counter = wc
		wall_active = wall_counter == 0
		if wall_counter == wall_counter_limit - wall_lifespan:
			emit_signal("destroy_wall")
		
@export var wall_counter_limit: int = 5
@export var wall_lifespan: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_freeze_gui_input(event: InputEvent) -> void:
	if !event.is_action_pressed("click"):
		return
	if !freeze_active:
		return
	freeze_counter = freeze_counter_limit
	emit_signal("freeze", freeze_chance)
	
func activate(result: bool) -> void:
	visible = result
	if visible:
		freeze_counter -= 1
		wall_counter -= 1


func _on_wall_gui_input(event: InputEvent) -> void:
	if !event.is_action_pressed("click"):
		return
	
	if !wall_active:
		return
	wall_counter = wall_counter_limit
	emit_signal("wall")
