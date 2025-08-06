extends Control

@export var freeze_chance: float = 0.6

@onready var freeze_card: Panel = $Cards/Freeze
@onready var wall_card: Panel = $Cards/Wall

signal freeze(chance: float)
signal wall()
signal destroy_wall()

var freeze_active: bool = true:
	set(a):
		freeze_active = a
		if freeze_active:
			freeze_card.modulate.a = 1.0
		else:
			freeze_card.modulate.a = 0.4
			
var freeze_counter: int : 
	set(fc):
		if fc < 0:
			fc = 0
		freeze_counter = fc
		freeze_active = freeze_counter == 0

@export var freeze_counter_limit: int = 3

var wall_active: bool = true:
	set(a):
		wall_active = a
		if wall_active:
			wall_card.modulate.a = 1.0
		else:
			wall_card.modulate.a = 0.4

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
	print(GameState.state["support"])
	for support in GameState.state["support"]:
		print(support)
		match support:
			"freeze":
				freeze_card.show()
			"wall":
				wall_card.show()


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
