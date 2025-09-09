class_name SpecialCard extends Panel

enum TYPE {HL, LL}
@export var type: TYPE
@export var special: CardSlots.SPECIALS
@export var cooldown: int

var cooldown_counter: int = 0 :
	set(cc):
		cooldown_counter = cc
		if cooldown_counter < 0:
			cooldown_counter = 0

signal on_click(s: CardSlots.SPECIALS)
signal on_click_full(s: SpecialCard)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		emit_signal("on_click", special)
		emit_signal("on_click_full", self)

func start_cooldown() -> void:
	cooldown_counter = cooldown
	modulate.a = 0.4

func countdown() -> void:
	cooldown_counter -= 1
	if cooldown_counter == 0:
		modulate.a = 1
